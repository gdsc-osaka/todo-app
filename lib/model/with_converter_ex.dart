import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/model/user.dart';

extension WithDocumentConverterEx<E> on DocumentReference {
  DocumentReference<DBUser> withUserConverter() => withConverter(
        fromFirestore: (snapshot, _) => DBUser.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  DocumentReference<Task> withTaskConverter() => withConverter(
        fromFirestore: (snapshot, _) => Task.fromJson(snapshot.data()!),
        toFirestore: (task, _) => task.toJson(),
      );
}

extension WithCollectionConverterEx<E> on CollectionReference {
  CollectionReference<DBUser> withUserConverter() => withConverter(
        fromFirestore: (snapshot, _) => DBUser.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  CollectionReference<Task> withTaskConverter() => withConverter(
        fromFirestore: (snapshot, _) => Task.fromJson(snapshot.data()!),
        toFirestore: (task, _) => task.toJson(),
      );
}
