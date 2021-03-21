#  LyricSnitcher

## Author

Luis David Goyes Garces

## Description

With this app you'll be able to get your favorite lyrics on screen. Just look for them by song and by artist.

## Notes:

1. There are two possible configurations to work with: _Debug_ and _Release_. You should have the _Debug_ build configuration enabled during development, which would allow you to work without the concrete dependencies to the real network (i.e. NSURLSession) and the real database (i.e. CoreData). If you want to test the real depedencies, you should have the _Release_ build configuration enabled, instead.

The app on _Debug_ mode will present present the lyrics for any song and artist you ask for. If you want to have the app present an error, fill in the word "error" in any of the fields (song or artist). On this same mode, the app will always have one new entry in the local storage repository, after initiation.

The app on _Release_ mode will perform the actual request to the api https://lyricsovh.docs.apiary.io/ for the song/artist you ask for. If there is any network error, you will be informed so. If the backend takes too long to respond, you will be informed that the lyrics were not found. On the same mode, the app will use an actual database. Data will persist through different initiations, though it will not persist through app installations.

2. The app was developed following the TDD cycle, consisting on writing a failing test first, then writing enough production code to make the test pass, and then recycle. Use the tests as active documentation. In addition, please keep this discipline during the development.

3. About the tests: Unit tests were the only kind of tests that were used. No acceptance test (UITest) was added to the project. No integration test was added to the project.

4. Database and Network dependencies adapt the [_HumbleObject_ pattern](https://martinfowler.com/bliki/HumbleObject.html). Most of that logic is already tested by apple, therefore some interfaces were used to decouple them from the actual project. 

5. Builds are not automated, since this application is for demonstrations purposes only.

## Posible future work

1. View controllers were not tested, as their logic was very simple. However, it might be a good idea to refactor the three viewcontrollers in this project (`SearchViewController`, `HistoryViewController` and `ReaderViewController`) to adapt the _HumbleObject_ pattern, by means of `Presenter`s.

## Contact

Feel free to issue any ticket to this repository, if you feel like reaching out.
