If fakefirestore throws:

`UnimplementedError
  package:fake_cloud_firestore/src/mock_query.dart 339:5                        MockQuery.endBeforeDocument`

then add :

```dart
 return MockQuery(this, (docs) {
      final index = docs.indexWhere((doc) {
        return doc.id == documentSnapshot.id;
      });

      if (index == -1) {
        throw PlatformException(
          code: 'Invalid Query',
          message: 'The document specified wasn\'t found',
        );
      }

      return docs.sublist(0, index + 1);
    });

```