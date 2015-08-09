# redmine_aws_admin

## Install

```bash
cd /path/to/redmine/
bundle install
rake redmine:plugins:migrate RAILS_ENV=production
```
And restart Redmine