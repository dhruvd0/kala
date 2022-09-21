// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
// import 'package:kala/utils/helper_bloc/content_pagination/content_pagination_bloc.dart';

// class DependencyBlocs{
//   static final blocs=[
//     BlocProvider(
//               lazy: false,
//               create: (context) => KalaUserBloc(),
//             ),
//             BlocProvider(
//               lazy: false,
//               create: (context) => KalaUserContentCubit(),
//             ),
//             BlocProvider(
//               lazy: false,
//               create: (context) => GalleryBloc(
//                 kalaUserBloc: context.read<KalaUserBloc>(),
//                 contentPaginationCubit: ContentPaginationCubit(
//                   collection: FirestorePaths.contentCollection,
//                   orderIsDescending: true,
//                   orderByField: 'uploadTimestamp',
//                 ),
//               ),
//             ),
//             BlocProvider(
//               lazy: false,
//               create: (context) => DashController(),
//             ),
//   ]
// }
