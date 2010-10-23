#!/usr/bin/env perl

use Test::More;
use SQL::Abstract::Test import => ['is_same_sql'];
use SQL::Abstract::Tree;

my $sqlat = SQL::Abstract::Tree->new;

my @sql = (
  "INSERT INTO artist DEFAULT VALUES",
  "INSERT INTO artist VALUES ()",
  "SELECT a, b, c FROM foo WHERE foo.a =1 and foo.b LIKE 'station'",
  "SELECT * FROM (SELECT * FROM foobar) WHERE foo.a =1 and foo.b LIKE 'station'",
  "SELECT * FROM lolz WHERE ( foo.a =1 ) and foo.b LIKE 'station'",
  "SELECT [screen].[id], [screen].[name], [screen].[section_id], [screen].[xtype] FROM [users_roles] [me] JOIN [roles] [role] ON [role].[id] = [me].[role_id] JOIN [roles_permissions] [role_permissions] ON [role_permissions].[role_id] = [role].[id] JOIN [permissions] [permission] ON [permission].[id] = [role_permissions].[permission_id] JOIN [permissionscreens] [permission_screens] ON [permission_screens].[permission_id] = [permission].[id] JOIN [screens] [screen] ON [screen].[id] = [permission_screens].[screen_id] WHERE ( [me].[user_id] = ? ) GROUP BY [screen].[id], [screen].[name], [screen].[section_id], [screen].[xtype]",
);

for (@sql) {
  is_same_sql($_, $sqlat->format($_), 'roundtrip works');
}


done_testing;
