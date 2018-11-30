use GSG::Gitc::CPANfile $_environment;

requires 'HealthCheck::Diagnostic';
requires 'Net::SFTP';
requires 'Net::SSH::Perl::Buffer';

test_requires 'Test::More';
test_requires 'Test::MockModule';
test_requires 'Test::Differences';

1;
