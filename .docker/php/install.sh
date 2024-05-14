rm -rf ./*
rm -rf ./.*

echo "-------------------------------------------------------------------"
echo "-                create symfony project                           -"
echo "-------------------------------------------------------------------"
symfony self:version

symfony new my_project --no-git --version=6.3 --php=8.2 --docker=false

echo "-------------------------------------------------------------------"
echo "-                   require packages                              -"
echo "-------------------------------------------------------------------"
cd ./my_project
cp .env .env.local

symfony composer require php:^8.2.0

symfony composer config allow-plugins.phpstan/extension-installer true
symfony composer config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
echo "-------------------------------------------------------------------"
echo "-               require dev packages                              -"
echo "-------------------------------------------------------------------"

symfony composer require --dev debug symfony/maker-bundle

symfony composer require --dev --no-interaction friendsofphp/php-cs-fixer phpstan/extension-installer phpstan/phpstan-symfony

symfony composer require --dev --no-interaction codeception/module-symfony \
codeception/module-datafactory codeception/module-asserts \
codeception/specify codeception/verify league/factory-muffin league/factory-muffin-faker

symfony composer config scripts.phpcsfixer "./vendor/bin/php-cs-fixer fix ./src --rules=@Symfony,@PHP82Migration --dry-run --diff"
symfony composer config scripts.phpcsfixer-fix "./vendor/bin/php-cs-fixer fix ./src --rules=@Symfony,@PHP82Migration"

symfony composer config scripts.phpstan "./vendor/bin/phpstan analyse ./src"
symfony composer config scripts.phpstan-baseline "./vendor/bin/phpstan analyse ./src --generate-baseline"

echo "-------------------------------------------------------------------"
echo "-                   Init Codeception                              -"
echo "-------------------------------------------------------------------"
#codecept bootstrap --namespace App\\Tests

echo "-------------------------------------------------------------------"
echo "-                          Ready                                  -"
echo "-------------------------------------------------------------------"
rm -rf .git
cd ..

chmod -R a+rw my_project

rsync -a my_project/ ./
rm -rf my_project
