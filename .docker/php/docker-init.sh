#!/usr/bin/env bash

# create new project if not exists
if [ ! -d "./public" ]; then
  . /home/install.sh
fi

echo "--------------------------------------------------------------------"
echo "-                            composer                              -"
echo "--------------------------------------------------------------------"
composer remove --unused
composer validate
symfony composer install --no-interaction
symfony composer -n check-platform-reqs

echo "-------------------------------------------------------------------"
echo "-                        php-cs-fixer                             -"
echo "-------------------------------------------------------------------"
#php-cs-fixer fix ./src --rules=@Symfony --verbose --show-progress=estimating

echo "-------------------------------------------------------------------"
echo "-                        phpstan                                  -"
echo "-------------------------------------------------------------------"
vendor/bin/phpstan analyse src
#./vendor/bin/psalm
echo "-------------------------------------------------------------------"
echo "-                        php-doc-check                            -"
echo "-------------------------------------------------------------------"
#vendor/bin/php-doc-check ./src

echo "-------------------------------------------------------------------"
echo "-                        phpcpd                                   -"
echo "-------------------------------------------------------------------"
#phpcpd --no-interaction src

echo "-------------------------------------------------------------------"
echo "-                        PHPMD                                    -"
echo "-------------------------------------------------------------------"
#phpmd ./src text codesize,unusedcode,naming,design,controversial,cleancode

echo "-------------------------------------------------------------------"
echo "-                            benchmarks                           -"
echo "-------------------------------------------------------------------"
#phpbench run --report=default --report=env
#phpbench xdebug:profile
#phpbench xdebug:trace

echo "-------------------------------------------------------------------"
echo "-                        testing                                  -"
echo "-------------------------------------------------------------------"
codecept clean
codecept run --steps --debug -vvv --coverage --coverage-xml --coverage-html

tail -f /dev/null
