// data/seed/default_categories.dart
import '../../model/category.dart';

final defaultCategories = <Category>[
  // Checklist
  Category(
    categoryType: CategoryType.checklist,
    name: 'Clothes',
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Documents',
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Toiletries',
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Electronics',
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Medications',
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Miscellaneous',
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'other',
  ),

  // Expense
  Category(
    categoryType: CategoryType.expense,
    name: 'Food & Drinks',
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Transport',
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Accommodation',
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Shopping',
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Attractions',
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Emergency',
  ),
   Category(
    categoryType: CategoryType.expense,
    name: 'other',
  ),

  // Itinerary Activity
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Sightseeing',
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Food',
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Shopping',
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Transport',
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Relaxation',
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Adventure',
  ),
   Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'other',
  ),
];
