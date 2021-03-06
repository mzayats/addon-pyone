# Copyright 2018 www.privaz.io Valletech AB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Use full path to ensure virtualenv compatibility
PYTHON = $(shell which python) 
GDS = $(shell which generateDS)

schemas = index.xsd

VPATH = src: pyone/xsd

all: pyone/bindings/__init__.py pyone/bindings/supbind.py

pyone/bindings/__init__.py pyone/bindings/supbind.py: $(schemas)
	mkdir -p pyone/bindings
	${PYTHON} ${GDS} -q -f -o pyone/bindings/supbind.py -s pyone/bindings/__init__.py --super=supbind --external-encoding=utf-8 --silence $^
	sed -i "s/import supbind/from . import supbind/" pyone/bindings/__init__.py
	sed -i "s/import sys/import sys\nfrom pyone.util import TemplatedType/" pyone/bindings/__init__.py
	sed -i "s/(supermod\./(TemplatedType, supermod\./g" pyone/bindings/__init__.py

.PHONY: clean build
clean:
	rm -f pyone/bindings/*.py
	rm -rf build dist

dist: clean all
	${PYTHON} setup.py sdist bdist_wheel
