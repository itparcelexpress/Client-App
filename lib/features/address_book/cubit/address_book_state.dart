import 'package:client_app/features/address_book/data/models/address_book_models.dart';
import 'package:equatable/equatable.dart';

abstract class AddressBookState extends Equatable {
  const AddressBookState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AddressBookInitial extends AddressBookState {}

// Loading states
class AddressBookLoading extends AddressBookState {}

class AddressBookCreating extends AddressBookState {}

class AddressBookUpdating extends AddressBookState {}

class AddressBookDeleting extends AddressBookState {}

// Success states
class AddressBookLoaded extends AddressBookState {
  final List<AddressBookEntry> entries;
  final int currentPage;
  final int totalPages;
  final int totalEntries;
  final bool hasMorePages;
  final String message;

  const AddressBookLoaded({
    required this.entries,
    required this.currentPage,
    required this.totalPages,
    required this.totalEntries,
    required this.hasMorePages,
    required this.message,
  });

  @override
  List<Object?> get props => [
    entries,
    currentPage,
    totalPages,
    totalEntries,
    hasMorePages,
    message,
  ];
}

class AddressBookEntryCreated extends AddressBookState {
  final AddressBookEntry entry;
  final String message;

  const AddressBookEntryCreated({required this.entry, required this.message});

  @override
  List<Object?> get props => [entry, message];
}

class AddressBookEntryUpdated extends AddressBookState {
  final AddressBookEntry entry;
  final String message;

  const AddressBookEntryUpdated({required this.entry, required this.message});

  @override
  List<Object?> get props => [entry, message];
}

class AddressBookEntryDeleted extends AddressBookState {
  final int entryId;
  final String message;

  const AddressBookEntryDeleted({required this.entryId, required this.message});

  @override
  List<Object?> get props => [entryId, message];
}

// Error states
class AddressBookError extends AddressBookState {
  final String message;
  final List<dynamic>? errors;

  const AddressBookError({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class AddressBookCreateError extends AddressBookState {
  final String message;
  final List<dynamic>? errors;

  const AddressBookCreateError({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class AddressBookUpdateError extends AddressBookState {
  final String message;
  final List<dynamic>? errors;

  const AddressBookUpdateError({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class AddressBookDeleteError extends AddressBookState {
  final String message;
  final List<dynamic>? errors;

  const AddressBookDeleteError({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}

// Empty state
class AddressBookEmpty extends AddressBookState {
  final String message;

  const AddressBookEmpty({this.message = 'No address book entries found'});

  @override
  List<Object?> get props => [message];
}
