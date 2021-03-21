#  LyricSnitcher

## Author

Luis David Goyes Garces

## Description

With this app you'll be able to get your favorite lyrics on screen. Just look for them by song and by artist.

## Notes:

1. There are two possible configurations to work with: _Debug_ and _Release_. You should have the _Debug_ build configuration enabled during development, which would allow you to work without the concrete dependencies to the real network (i.e. NSURLSession) and the real database (i.e. CoreData). If you want to test the real depedencies, you should have the _Release_ build configuration enabled, instead.
2. The app was developed following the TDD cycle, consisting on writing a failing test first, then writing enough production code to make the test pass, and then recycle. Use the tests as active documentation. In addition, please keep this discipline during the development.
3. About the tests: Unit tests were the only kind of tests that were used. No acceptance test (UITest) was added to the project. No integration test was added to the project.
4. Database and Network dependencies adapt the [_HumbleObject_ pattern](https://martinfowler.com/bliki/HumbleObject.html). Most of that logic is already tested by apple, therefore some interfaces were used to decouple them from the actual project. 
5. Builds are not automated, since this application is for demonstrations purposes only.

## Posible future work

1. View controllers were not tested, as their logic was very simple. However, it might be a good idea to refactor the three viewcontrollers in this project (`SearchViewController`, `HistoryViewController` and `ReaderViewController`) to adapt the _HumbleObject_ pattern, by means of `Presenter`s.

## Contact

Feel free to issue any ticket to this repository, if you feel like reaching out.
