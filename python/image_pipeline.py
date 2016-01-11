
import csv
import collections
import json
import os
import pickle
import shutil
import time

import luigi
import requests

from joakim import image_utils

# "perceptual image hashing, with a luigi twist.


class BaseImageTask(luigi.Task):

    def task_name(self):
        return str(self.__class__.__name__)

    def default_input_dir(self):
        return '/imghash/data_in/'

    def default_output_dir(self):
        return '/imghash/data/'

    def images_dir(self):
        return '/imghash/data/images/'

    def default_output_filename(self, filetype='txt'):
        return "{0}{1}.{2}".format(self.default_output_dir(), self.task_name().lower(), filetype)

    def image_hashes_filename(self):
        return "{0}{1}".format(self.default_output_dir(), 'image_hashes.json')

    def image_hashes_pickle_filename(self):
        return "{0}{1}".format(self.default_output_dir(), 'image_hashes.pkl')

    def image_matches_filename(self):
        return "{0}{1}".format(self.default_output_dir(), 'image_matches.json')

    def images_urls_filename(self):
        return "{0}{1}".format(self.default_input_dir(), 'profile_image_urls.csv')

    def output(self):
        return luigi.LocalTarget(self.default_output_filename())

    def base_run(self):
        tname, start_time = self.task_name(), time.time()
        with self.output().open('w') as output:
            output.write('{0} start_time {1}\n'.format(tname, start_time))
        elapsed_time = time.time() - start_time
        print("{0} run() completed in {1}".format(tname, elapsed_time))

    def save_pickle(self, obj, file_name):
        with open(file_name, 'wb') as file_handle:
            pickle.dump(obj, file_handle)

    def load_pickle(self, file_name):
        with open(file_name, 'rb') as file_handle:
            return pickle.load(file_handle)


class ImageFetchTask(BaseImageTask):

    def image_urls_list(self):
        urls = list()
        with open(self.images_urls_filename(), 'rt') as csvfile:
            has_header = csv.Sniffer().has_header(csvfile.read(1024))
            csvfile.seek(0)
            reader = csv.reader(csvfile)
            if has_header:
                next(reader)
            for row in reader:
                print('^'.join(row))
                urls.append(row)
        return urls

    def run(self):
        tname, start_time = self.task_name(), time.time()
        urls_list = self.image_urls_list()

        for url_info in urls_list:
            dir = self.images_dir()
            pid = url_info[0].strip()
            src = url_info[1].strip()
            url = url_info[3].strip()
            out = "{0}/orig-{1}-{2}.jpg".format(dir, pid, src)
            print("out: {0} <- {1}".format(out, url))
            if True:
                response = requests.get(url, stream=True)
                with open(out, 'wb') as out_file:
                    shutil.copyfileobj(response.raw, out_file)
                del response

        with self.output().open('w') as output:
            output.write('{0} start_time {1}\n'.format(tname, start_time))


class ImageNormalizeTask(BaseImageTask):

    def requires(self):
        return ImageFetchTask()

    def run(self):
        tname, start_time = self.task_name(), time.time()
        dir = self.images_dir()
        thumb_size = (200, 200) # (128, 128)

        for root, dir_names, file_names in os.walk(dir):
            for filename in file_names:
                try:
                    orig_filename = os.path.join(root, filename)
                    norm_filename = orig_filename.replace("orig-", "norm-")
                    image_utils.save_normalized_image(orig_filename, norm_filename)
                    print("{0} normalized file: {1}".format(tname, norm_filename))
                except IOError:
                    print("cannot create thumbnail for: {0}".format(orig_filename))

        with self.output().open('w') as output:
            output.write('{0} start_time {1}\n'.format(tname, start_time))


class ImageHashTask(BaseImageTask):

    def requires(self):
        return ImageNormalizeTask()

    def run(self):
        tname, start_time = self.task_name(), time.time()
        pickle_obj = dict()
        dir = self.images_dir()

        for root, dir_names, file_names in os.walk(dir):
            for filename in file_names:
                abs_filename = os.path.join(root, filename)
                hashes_dict = image_utils.hash_image(abs_filename)
                pickle_obj[abs_filename] = hashes_dict

        self.save_pickle(pickle_obj, self.image_hashes_pickle_filename())

    def output(self):
        return luigi.LocalTarget(self.image_hashes_pickle_filename())


class ImageHashMatchTask(BaseImageTask):

    max_ham_dist = luigi.IntParameter("max_ham_dist")
    all_matches, true_matches, false_matches = dict(), list(), list()
    all_matches["true_matches"]  = true_matches
    all_matches["false_matches"] = false_matches

    def requires(self):
        return ImageHashTask()

    def read_hashes_file(self):
        tname, start_time = self.task_name(), time.time()
        infile = self.image_hashes_filename()
        print("{0} read_hashes_file: {1}".format(tname, infile))
        with open (infile, "r") as json_file:
            return json.loads(json_file.read())

    def run(self):
        tname, start_time = self.task_name(), time.time()
        file_matches = list()
        counter = collections.defaultdict(int)

        pickle_obj = self.load_pickle(self.image_hashes_pickle_filename())
        print("PICKLE OBJECT LOADED: {0}".format(len(pickle_obj)))

        keys = sorted(pickle_obj.keys())
        for key1 in keys:
            for key2 in keys:
                if self._compare_these_keys(key1, key2):
                    d1 = pickle_obj[key1]
                    d2 = pickle_obj[key2]
                    algorithms = sorted(d1.keys())
                    for alg in algorithms:
                        hash1 = d1[alg]
                        hash2 = d2[alg]
                        diff = image_utils.hash_difference(alg, hash1, hash2)
                        result = "{0} {1} {2} {3}".format(diff, alg, key1, key2)

                        if diff <= self.max_ham_dist:
                            self.true_matches.append(result)
                            counter[alg] += 1
                        else:
                            self.false_matches.append(result)

        json_str = json.dumps(counter)
        print("counts: {0}".format(json_str))

        json_str = json.dumps(self.all_matches, sort_keys=False, indent=2)
        with self.output().open('w') as output:
            output.write(json_str)

    def output(self):
        return luigi.LocalTarget(self.image_matches_filename())

    def _compare_these_keys(self, key1, key2):
        if key1 == key2:
            return False
        if 'norm-' not in key1:
            return False
        if 'norm-' not in key2:
            return False
        return True


if __name__ == '__main__':
    luigi.run(['ImageHashMatchTask', '--workers', '1', '--local-scheduler'])
