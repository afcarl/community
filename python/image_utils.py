import photohash

from PIL import Image

from joakim import imagehash


def save_normalized_image(orig_filename, norm_filename, thumb_size=(200, 200)):
    try:
        img = Image.open(orig_filename).convert("L")
        img.thumbnail(thumb_size)
        img.save(norm_filename, "JPEG")
        return True
    except:
        raise


def hash_image(img_filename):
    hashes_dict = dict()
    try:
        img = Image.open(img_filename)
        hashes_dict['photohash_average_hash'] = photohash.average_hash(img_filename)
        hashes_dict['imagehash_average_hash'] = imagehash.average_hash(img)
        hashes_dict['imagehash_phash'] = imagehash.phash(img)
    except:
        print("error in hash_image on: {0}".format(img_filename))
    return hashes_dict


def hash_difference(algorithm, hash1, hash2):
    if algorithm and hash1 and hash2:
        if algorithm == 'photohash_average_hash':
            return photohash_hamming_distance(hash1, hash2)
        else:
            return hash1 - hash2
    else:
        return high_value_hash()


def photohash_hamming_distance(hash1, hash2):
    if hash1 and hash2:
        if len(hash1) != len(hash2):
            return high_value_hash()
        else:
            return sum(map(lambda x: 0 if x[0] == x[1] else 1, zip(hash1, hash2)))
    else:
        return high_value_hash()


def high_value_hash():
    return 1000
