=begin

Copyright (C) 2012 Chris Joakim, joakimsoftware.com.

Ruby Rakefile to copy a Maven-based Java project to a simple Eclipse Java project.

Instructions:

1.  The source Maven-based (source) project should be present and installed on your computer.
    mvn clean install
    
2.  Create a standard Java project in Eclipse; this is the target project.
    Create directory 'lib' for jars, 'resources' for compile classpath resources,
    'conf' for configuration files, and 'scripts' for shell scripts.

3.  Run command 'mvn dependency:build-classpath' in your Maven project to generate the
    list of necessary jar files.  Leave this terminal/shell window open so that you can
    copy & paste the classpath value.
    
4.  Edit this Rakefile.  Change the three values indicated below.
    - maven_project_root_directory
    - eclipse_project_root_directory
    - maven_generated_classpath

5.  Open a terminal/shell window to where this Rakefile is located.
    Run command 'rake -T' to see the list of commands in this Rakefile.
    You should see the following:

    rake copy2eclipse               # Copy files to Eclipse
    rake generate_copy_jars_script  # Generate shell script to copy the jar files to Eclipse
    rake list_classpath             # List the mvn-generated classpath

6.  Generate and run the script to copy the JAR files to your Eclipse project.

    rake generate_copy_jars_script > copy_jars.sh
    
    Then edit and execute 'copy_jars.sh'.  The first line should be deleted.
    
    Refresh your Eclipse project, and observe that the jar files are now in the lib directory.
    Also edit the classpath settings in your Eclipse project to add these jars.
    
7.  Copy the code and resource files to your Eclipse project.
    
    rake copy2eclipse

    Refresh your Eclipse project, and observe that the source code is in the src directory,
    and the resource files are in the resource directory.
    
    Build/recompile your Eclipse project.
    
    Enjoy your simplified project and development experience!
    
=end

require 'rubygems'
require 'rake'

# Edit this value to point to where your mvn project is located.
def maven_project_root_directory
  '/downloads/mahout'
end

# Edit this value to point to where your eclipse project is located.
def eclipse_project_root_directory
  #'/cjoakim/workspace/Mahout'
  '/cjoakim/github/cjoakim/workspace/Mahout'
end

# Edit this value; paste in the classpath produced by 'mvn dependency:build-classpath'
# when executed from the root of your maven project.
def maven_generated_classpath
  text = <<HEREDOC
/Users/cjoakim/.m2/repository/antlr/antlr/2.7.7/antlr-2.7.7.jar:/Users/cjoakim/.m2/repository/cglib/cglib-nodep/2.2/cglib-nodep-2.2.jar:/Users/cjoakim/.m2/repository/com/ecyrd/speed4j/speed4j/0.9/speed4j-0.9.jar:/Users/cjoakim/.m2/repository/com/github/stephenc/jamm/0.2.2/jamm-0.2.2.jar:/Users/cjoakim/.m2/repository/com/github/stephenc/eaio-uuid/uuid/3.2.0/uuid-3.2.0.jar:/Users/cjoakim/.m2/repository/com/github/stephenc/high-scale-lib/high-scale-lib/1.1.2/high-scale-lib-1.1.2.jar:/Users/cjoakim/.m2/repository/com/google/guava/guava/r09/guava-r09.jar:/Users/cjoakim/.m2/repository/com/googlecode/concurrentlinkedhashmap/concurrentlinkedhashmap-lru/1.1/concurrentlinkedhashmap-lru-1.1.jar:/Users/cjoakim/.m2/repository/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar:/Users/cjoakim/.m2/repository/com/thoughtworks/xstream/xstream/1.3.1/xstream-1.3.1.jar:/Users/cjoakim/.m2/repository/commons-beanutils/commons-beanutils/1.7.0/commons-beanutils-1.7.0.jar:/Users/cjoakim/.m2/repository/commons-beanutils/commons-beanutils-core/1.8.0/commons-beanutils-core-1.8.0.jar:/Users/cjoakim/.m2/repository/commons-cli/commons-cli/1.2/commons-cli-1.2.jar:/Users/cjoakim/.m2/repository/commons-codec/commons-codec/1.4/commons-codec-1.4.jar:/Users/cjoakim/.m2/repository/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar:/Users/cjoakim/.m2/repository/commons-configuration/commons-configuration/1.6/commons-configuration-1.6.jar:/Users/cjoakim/.m2/repository/commons-dbcp/commons-dbcp/1.4/commons-dbcp-1.4.jar:/Users/cjoakim/.m2/repository/commons-digester/commons-digester/1.7/commons-digester-1.7.jar:/Users/cjoakim/.m2/repository/commons-httpclient/commons-httpclient/3.0.1/commons-httpclient-3.0.1.jar:/Users/cjoakim/.m2/repository/commons-io/commons-io/2.0.1/commons-io-2.0.1.jar:/Users/cjoakim/.m2/repository/commons-lang/commons-lang/2.6/commons-lang-2.6.jar:/Users/cjoakim/.m2/repository/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar:/Users/cjoakim/.m2/repository/commons-pool/commons-pool/1.5.6/commons-pool-1.5.6.jar:/Users/cjoakim/.m2/repository/jakarta-regexp/jakarta-regexp/1.4/jakarta-regexp-1.4.jar:/Users/cjoakim/.m2/repository/javax/servlet/servlet-api/2.5/servlet-api-2.5.jar:/Users/cjoakim/.m2/repository/jfree/jcommon/1.0.12/jcommon-1.0.12.jar:/Users/cjoakim/.m2/repository/jfree/jfreechart/1.0.13/jfreechart-1.0.13.jar:/Users/cjoakim/.m2/repository/jline/jline/0.9.94/jline-0.9.94.jar:/Users/cjoakim/.m2/repository/junit/junit/4.8.2/junit-4.8.2.jar:/Users/cjoakim/.m2/repository/log4j/log4j/1.2.16/log4j-1.2.16.jar:/Users/cjoakim/.m2/repository/me/prettyprint/hector-core/0.8.0-2/hector-core-0.8.0-2.jar:/Users/cjoakim/.m2/repository/org/antlr/antlr/3.2/antlr-3.2.jar:/Users/cjoakim/.m2/repository/org/antlr/antlr-runtime/3.2/antlr-runtime-3.2.jar:/Users/cjoakim/.m2/repository/org/antlr/stringtemplate/3.2/stringtemplate-3.2.jar:/Users/cjoakim/.m2/repository/org/apache/cassandra/cassandra-all/0.8.1/cassandra-all-0.8.1.jar:/Users/cjoakim/.m2/repository/org/apache/cassandra/cassandra-thrift/0.8.1/cassandra-thrift-0.8.1.jar:/Users/cjoakim/.m2/repository/org/apache/cassandra/deps/avro/1.4.0-cassandra-1/avro-1.4.0-cassandra-1.jar:/Users/cjoakim/.m2/repository/org/apache/commons/commons-compress/1.2/commons-compress-1.2.jar:/Users/cjoakim/.m2/repository/org/apache/commons/commons-math/2.2/commons-math-2.2.jar:/Users/cjoakim/.m2/repository/org/apache/hadoop/hadoop-core/0.20.204.0/hadoop-core-0.20.204.0.jar:/Users/cjoakim/.m2/repository/org/apache/httpcomponents/httpclient/4.0.1/httpclient-4.0.1.jar:/Users/cjoakim/.m2/repository/org/apache/httpcomponents/httpcore/4.0.1/httpcore-4.0.1.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-analyzers/3.5.0/lucene-analyzers-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-benchmark/3.5.0/lucene-benchmark-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-core/3.5.0/lucene-core-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-facet/3.5.0/lucene-facet-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-highlighter/3.5.0/lucene-highlighter-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-memory/3.5.0/lucene-memory-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-queries/3.5.0/lucene-queries-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/lucene/lucene-xercesImpl/3.5.0/lucene-xercesImpl-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/mahout/mahout-collections/1.0/mahout-collections-1.0.jar:/Users/cjoakim/.m2/repository/org/apache/mahout/mahout-core/0.7-SNAPSHOT/mahout-core-0.7-SNAPSHOT.jar:/Users/cjoakim/.m2/repository/org/apache/mahout/mahout-core/0.7-SNAPSHOT/mahout-core-0.7-SNAPSHOT-tests.jar:/Users/cjoakim/.m2/repository/org/apache/mahout/mahout-integration/0.7-SNAPSHOT/mahout-integration-0.7-SNAPSHOT.jar:/Users/cjoakim/.m2/repository/org/apache/mahout/mahout-math/0.7-SNAPSHOT/mahout-math-0.7-SNAPSHOT.jar:/Users/cjoakim/.m2/repository/org/apache/mahout/mahout-math/0.7-SNAPSHOT/mahout-math-0.7-SNAPSHOT-tests.jar:/Users/cjoakim/.m2/repository/org/apache/mahout/commons/commons-cli/2.0-mahout/commons-cli-2.0-mahout.jar:/Users/cjoakim/.m2/repository/org/apache/solr/solr-commons-csv/3.5.0/solr-commons-csv-3.5.0.jar:/Users/cjoakim/.m2/repository/org/apache/thrift/libthrift/0.6.1/libthrift-0.6.1.jar:/Users/cjoakim/.m2/repository/org/codehaus/jackson/jackson-core-asl/1.8.2/jackson-core-asl-1.8.2.jar:/Users/cjoakim/.m2/repository/org/codehaus/jackson/jackson-mapper-asl/1.8.2/jackson-mapper-asl-1.8.2.jar:/Users/cjoakim/.m2/repository/org/easymock/easymock/3.0/easymock-3.0.jar:/Users/cjoakim/.m2/repository/org/mongodb/bson/2.5/bson-2.5.jar:/Users/cjoakim/.m2/repository/org/mongodb/mongo-java-driver/2.5/mongo-java-driver-2.5.jar:/Users/cjoakim/.m2/repository/org/mortbay/jetty/jetty/6.1.22/jetty-6.1.22.jar:/Users/cjoakim/.m2/repository/org/mortbay/jetty/jetty-util/6.1.22/jetty-util-6.1.22.jar:/Users/cjoakim/.m2/repository/org/mortbay/jetty/servlet-api/2.5-20081211/servlet-api-2.5-20081211.jar:/Users/cjoakim/.m2/repository/org/objenesis/objenesis/1.2/objenesis-1.2.jar:/Users/cjoakim/.m2/repository/org/slf4j/jul-to-slf4j/1.6.1/jul-to-slf4j-1.6.1.jar:/Users/cjoakim/.m2/repository/org/slf4j/slf4j-api/1.6.1/slf4j-api-1.6.1.jar:/Users/cjoakim/.m2/repository/org/slf4j/slf4j-jcl/1.6.1/slf4j-jcl-1.6.1.jar:/Users/cjoakim/.m2/repository/org/slf4j/slf4j-log4j12/1.6.1/slf4j-log4j12-1.6.1.jar:/Users/cjoakim/.m2/repository/org/uncommons/maths/uncommons-maths/1.2.2/uncommons-maths-1.2.2.jar:/Users/cjoakim/.m2/repository/org/uncommons/watchmaker/watchmaker-framework/0.6.2/watchmaker-framework-0.6.2.jar:/Users/cjoakim/.m2/repository/org/uncommons/watchmaker/watchmaker-swing/0.6.2/watchmaker-swing-0.6.2.jar:/Users/cjoakim/.m2/repository/org/yaml/snakeyaml/1.6/snakeyaml-1.6.jar:/Users/cjoakim/.m2/repository/xml-apis/xml-apis/1.0.b2/xml-apis-1.0.b2.jar:/Users/cjoakim/.m2/repository/xpp3/xpp3_min/1.1.4c/xpp3_min-1.1.4c.jar
HEREDOC
  text
end

def parse_classpath
  delim = (windows?) ? ';' : ':'
  maven_generated_classpath.split(delim)
end

def windows?
  processor, platform, *rest = RUBY_PLATFORM.split("-") 
  platform.downcase == 'mswin32'
end 

def make_eclipse_directory_stucture
  FileUtils.mkdir_p(eclipse_project_root_directory)
  FileUtils.mkdir_p("#{eclipse_project_root_directory}/conf")
  FileUtils.mkdir_p("#{eclipse_project_root_directory}/lib")
  FileUtils.mkdir_p("#{eclipse_project_root_directory}/resources")
  FileUtils.mkdir_p("#{eclipse_project_root_directory}/scripts") 
  FileUtils.mkdir_p("#{eclipse_project_root_directory}/src")
end

def workspace_path(mvn_path)
  ep = eclipse_path(mvn_path)
  "#{eclipse_project_root_directory}/#{ep}"
end 
  
def eclipse_path(mvn_path)
  ignore_types.each { | suffix | 
    return nil if mvn_path.end_with?(suffix) 
  }
  return 'scripts/'   if mvn_path.end_with?('.sh')
  return "resources/" if mvn_path.index('/resources/')
  return "conf/"      if mvn_path.index('/conf/')
  idx = mvn_path.index('/java/org/') 
  return "src/#{mvn_path[idx + 6, 999]}" if idx
  nil
end

def ignore_types
  %w(.class .t .pom)
end

desc "List the mvn-generated classpath"
task :list_classpath do
  parse_classpath.each { | path | puts path }
end

desc "Generate shell script to copy the jar files to Eclipse"
task :generate_copy_jars_script do
  make_eclipse_directory_stucture 
  puts '#!/bin/bash '
  puts ''
  parse_classpath.each { | path | 
    puts "cp #{path.strip} #{eclipse_project_root_directory}/lib"
  }
end

desc "Copy files to Eclipse"
task :copy2eclipse do
  make_eclipse_directory_stucture 
  maven_filenames = Dir["#{maven_project_root_directory}/**/*.*"]
  maven_filenames.each { | mvn_path |
    if eclipse_path(mvn_path)
      tgt = workspace_path(mvn_path) 
      puts "copying #{mvn_path} to #{tgt}"
      FileUtils.mkdir_p(File.dirname(tgt))
      FileUtils.cp(mvn_path, tgt) 
    else
      puts "excluding: #{mvn_path}"
    end 
  }
end 
