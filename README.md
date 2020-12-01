# poc-resources

## Secret Scanning for Repositories

### Custom Patterns for Git Secret
Custom patterns that we use to scan repositories are found here: [git-secrets-pattern.txt](./git-secrets-pattern.txt)

### Daily Repository Scan
Daily scans of a set of repositories runs at 10:00 am UTC. 

The specified repositories we scan are in the [circleci configuration file](./.circleci/config.yml).

#### Script
##### Usage
```bash
./scan-repos_for_secrets.sh {repositories-whitespace-separated}

Examples: 
./scan_repos_for_secrets.sh poc-resources
./scan_repos_for_secrets.sh poc-resources poc-va-api
```
##### Output
Results are printed to stdout, separated by repository and their respective results. 

Exit Code value is based on the number of repositories that failed the scan. (ex. if 2 repositories out of 5 fail, exit code value is 2)
