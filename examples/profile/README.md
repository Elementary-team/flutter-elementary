# Profile

Combining [Elementary](https://pub.dev/packages/elementary)
and [Bloc](https://pub.dev/packages/bloc).

This example shows how a profile can be filled out, saved on a server (a mock server), and, if
necessary, edited once filled out.

Bloc is used to track profile state (loaded, edited, saved). State interfaces are added to declare
which events are applicable to which states.

### A profile can be in one of the following states:

- **InitProfileState** - the profile is initialized with no actions yet taken.


- **ProfileLoadingState** - the profile is loading.


- **ErrorProfileLoadingState** - the profile failed to load from server.


- **ProfileState** - the profile is loaded successfully.


- **PendingProfileState** - the profile contains pending changes.


- **SavingProfileState** - the profile is being saved on server.


- **ProfileSavedSuccessfullyState** - the profile is successfully saved on server.


- **ProfileSaveFailedState** - the profile failed to be saved on server.

### Bloc diagram

![Bloc diagram](res/bloc_diagram.png)

[PersonalDataScreen](lib/features/profile/screens/personal_data_screen/personal_data_screen.dart), [PlaceResidenceScreen](lib/features/profile/screens/place_residence/place_residence_screen.dart), [InterestsScreen](lib/features/profile/screens/interests_screen/interests_screen.dart),
and [AboutMeScreen](lib/features/profile/screens/about_me_screen/about_me_screen.dart) contain presentation logic, therefore they are written
with [Elementary](https://pub.dev/packages/elementary). Thanks to that, we can separate presentation
from presentation logic and business logic.

[CancelButton](lib/features/profile/widgets/cancel_button/cancel_button.dart) is made into a
separate widget because it has its own logic regardless of where it is used.

Widget [FieldWithSuggestions](lib/features/profile/screens/place_residence/widgets/field_with_suggestions_widget/field_with_suggestions_widget.dart)
has extensive presentation logic and separate business logic that shows suggestions from the
repository when users enter the name of their city.
