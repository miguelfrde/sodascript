Sodascript: Contributing Guide
==============================


## Ruby coding style

Try to follow this [Ruby style guide](https://github.com/bbatsov/ruby-style-guide) as much as possible.


## Developing a new feature or fixing some feature 

1. Create or edit your feature.

2. Create your feature branch:

    ```$ git checkout -b <your-feature-name>```

3. Write new tests for you feature and run all tests:

    ```$ rake test```

4. Check your test code coverage by opening `coverage/index.html`, try to cover as much as possible.

5. If your tests passed push your feature to Github:

    ```$ git push origin <your-feature-name>``` 

6. Go to Github and create a pull request. If you are using `hub` aliased as `git` just run:

    ```$ git pull-request```

If your pull request closes an issue. Please close it from the pull-request content or from the commit. If you don't know how to do this, [read this](https://help.github.com/articles/closing-issues-via-commit-messages).

If you need to add more commits to a pull request, just push to that branch as shown in #4.

If you need to fix a commit that you have already pushed to the pull-request, you can do it [squashing commits](http://davidwalsh.name/squash-commits-git). Note: you will need to force push after doing this:

```$ git push -f origin <your-feature-name>```

Don't forget to do `$ git pull` before editing anything, so that you are always working on the latest version.

If you are working on a branch that is behind master, do `$ git rebase -i master` to integrate changes from master into the branch you are working. Note: you may need to solve merge conflicts if this happens.


## Testing

We use `minitest` for testing. It's also prefered to write spec tests instead of unit tests, since they are more descriptive on what the module/method/class/feature should do. Run one of:

```
$ rake test
$ bundle exec rake test
```

We use `SimpleCov` for test code coverage. After running your tests, you can open the file `coverage/index.html` to see how much of the code is covered by the current tests. Try to get 100% coverage.

## Documentation

We use rdoc for documentation. There are two ways of generating documentation:

- Public documentation: includes all public methods, attribute accessors, modules, classes. Run:

	```$ rake rdoc```

- Private documentation: includes all public documentation and also private methods. Run:

	```$ rake rdocdev```

