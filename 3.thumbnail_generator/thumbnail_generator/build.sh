#!/bin/bash
set -eo pipefail
gradle -q packageLibs
mv build/distributions/thumbnail_generator.zip ../thumbnail_generator_lib.zip
gradle build -i
mv build/distributions/thumbnail_generator.zip ../thumbnail_generator_jar.zip
