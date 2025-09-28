import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/location_models.dart';

/// Service for managing country localization and caching
class CountryLocalizationService {
  static const String _countriesBoxName = 'countries';
  static const String _countryTranslationsBoxName = 'country_translations';

  // Hive boxes
  static Box<Country>? _countriesBox;
  static Box<CountryTranslation>? _translationsBox;

  // Cache for quick access
  static List<Country> _cachedCountries = [];
  static Map<int, CountryTranslation> _cachedTranslations = {};

  // Initialize the service
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CountryAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CountryTranslationAdapter());
    }

    // Open boxes
    _countriesBox = await Hive.openBox<Country>(_countriesBoxName);
    _translationsBox = await Hive.openBox<CountryTranslation>(
      _countryTranslationsBoxName,
    );

    // Load initial data
    await _loadInitialData();
  }

  // Load initial data from JSON files
  static Future<void> _loadInitialData() async {
    if (_countriesBox!.isEmpty) {
      await _loadCountriesFromJson();
    }
    if (_translationsBox!.isEmpty) {
      await _loadTranslationsFromJson();
    }

    // Cache data for quick access
    _cachedCountries = _countriesBox!.values.toList();
    _cachedTranslations = Map.fromEntries(
      _translationsBox!.values.map((t) => MapEntry(t.countryId, t)),
    );
  }

  // Load countries from JSON
  static Future<void> _loadCountriesFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/jsons/countries.json',
      );
      final jsonData = json.decode(jsonString);
      final response = CountryResponse.fromJson(jsonData);

      for (final country in response.data) {
        await _countriesBox!.put(country.id, country);
      }
    } catch (e) {
      debugPrint('Error loading countries from JSON: $e');
    }
  }

  // Load translations from JSON
  static Future<void> _loadTranslationsFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/jsons/country_translations.json',
      );
      final jsonData = json.decode(jsonString);
      final translations =
          (jsonData['translations'] as List)
              .map((item) => CountryTranslation.fromJson(item))
              .toList();

      for (final translation in translations) {
        await _translationsBox!.put(translation.countryId, translation);
      }
    } catch (e) {
      debugPrint('Error loading country translations from JSON: $e');
      // Create fallback translations for common countries
      await _createFallbackTranslations();
    }
  }

  // Create fallback translations for common countries
  static Future<void> _createFallbackTranslations() async {
    final fallbackTranslations = [
      CountryTranslation(countryId: 64, arName: 'مصر', enName: 'Egypt'),
      CountryTranslation(
        countryId: 191,
        arName: 'المملكة العربية السعودية',
        enName: 'Saudi Arabia',
      ),
      CountryTranslation(
        countryId: 229,
        arName: 'الإمارات العربية المتحدة',
        enName: 'United Arab Emirates',
      ),
      CountryTranslation(countryId: 117, arName: 'الكويت', enName: 'Kuwait'),
      CountryTranslation(countryId: 178, arName: 'قطر', enName: 'Qatar'),
      CountryTranslation(countryId: 17, arName: 'البحرين', enName: 'Bahrain'),
      CountryTranslation(countryId: 165, arName: 'عُمان', enName: 'Oman'),
      CountryTranslation(countryId: 111, arName: 'الأردن', enName: 'Jordan'),
      CountryTranslation(countryId: 121, arName: 'لبنان', enName: 'Lebanon'),
      CountryTranslation(
        countryId: 231,
        arName: 'الولايات المتحدة',
        enName: 'United States',
      ),
      CountryTranslation(
        countryId: 230,
        arName: 'المملكة المتحدة',
        enName: 'United Kingdom',
      ),
      CountryTranslation(countryId: 38, arName: 'كندا', enName: 'Canada'),
      CountryTranslation(countryId: 82, arName: 'ألمانيا', enName: 'Germany'),
      CountryTranslation(countryId: 75, arName: 'فرنسا', enName: 'France'),
      CountryTranslation(countryId: 107, arName: 'إيطاليا', enName: 'Italy'),
      CountryTranslation(countryId: 205, arName: 'إسبانيا', enName: 'Spain'),
      CountryTranslation(
        countryId: 155,
        arName: 'هولندا',
        enName: 'Netherlands',
      ),
      CountryTranslation(countryId: 14, arName: 'النمسا', enName: 'Austria'),
      CountryTranslation(countryId: 21, arName: 'بلجيكا', enName: 'Belgium'),
      CountryTranslation(countryId: 164, arName: 'النرويج', enName: 'Norway'),
      CountryTranslation(countryId: 74, arName: 'فنلندا', enName: 'Finland'),
      CountryTranslation(countryId: 211, arName: 'السويد', enName: 'Sweden'),
      CountryTranslation(
        countryId: 212,
        arName: 'سويسرا',
        enName: 'Switzerland',
      ),
      CountryTranslation(countryId: 58, arName: 'الدنمارك', enName: 'Denmark'),
      CountryTranslation(
        countryId: 57,
        arName: 'جمهورية التشيك',
        enName: 'Czech Republic',
      ),
      CountryTranslation(
        countryId: 126,
        arName: 'ليتوانيا',
        enName: 'Lithuania',
      ),
      CountryTranslation(countryId: 120, arName: 'لاتفيا', enName: 'Latvia'),
      CountryTranslation(countryId: 68, arName: 'إستونيا', enName: 'Estonia'),
      CountryTranslation(countryId: 175, arName: 'بولندا', enName: 'Poland'),
      CountryTranslation(
        countryId: 176,
        arName: 'البرتغال',
        enName: 'Portugal',
      ),
      CountryTranslation(countryId: 99, arName: 'المجر', enName: 'Hungary'),
      CountryTranslation(
        countryId: 197,
        arName: 'سلوفاكيا',
        enName: 'Slovakia',
      ),
      CountryTranslation(
        countryId: 198,
        arName: 'سلوفينيا',
        enName: 'Slovenia',
      ),
      CountryTranslation(countryId: 193, arName: 'صربيا', enName: 'Serbia'),
      CountryTranslation(
        countryId: 27,
        arName: 'البوسنة والهرسك',
        enName: 'Bosnia and Herzegovina',
      ),
      CountryTranslation(countryId: 54, arName: 'كرواتيا', enName: 'Croatia'),
      CountryTranslation(countryId: 180, arName: 'رومانيا', enName: 'Romania'),
      CountryTranslation(countryId: 33, arName: 'بلغاريا', enName: 'Bulgaria'),
      CountryTranslation(countryId: 181, arName: 'روسيا', enName: 'Russia'),
      CountryTranslation(
        countryId: 112,
        arName: 'كازاخستان',
        enName: 'Kazakhstan',
      ),
      CountryTranslation(countryId: 81, arName: 'جورجيا', enName: 'Georgia'),
      CountryTranslation(countryId: 11, arName: 'أرمينيا', enName: 'Armenia'),
      CountryTranslation(
        countryId: 118,
        arName: 'قيرغيزستان',
        enName: 'Kyrgyzstan',
      ),
      CountryTranslation(
        countryId: 234,
        arName: 'أوزبكستان',
        enName: 'Uzbekistan',
      ),
      CountryTranslation(
        countryId: 215,
        arName: 'طاجيكستان',
        enName: 'Tajikistan',
      ),
      CountryTranslation(countryId: 223, arName: 'تركيا', enName: 'Turkey'),
      CountryTranslation(countryId: 103, arName: 'إيران', enName: 'Iran'),
      CountryTranslation(countryId: 104, arName: 'العراق', enName: 'Iraq'),
      CountryTranslation(countryId: 213, arName: 'سوريا', enName: 'Syria'),
      CountryTranslation(countryId: 106, arName: 'إسرائيل', enName: 'Israel'),
      CountryTranslation(
        countryId: 168,
        arName: 'فلسطين',
        enName: 'Palestinian Territory',
      ),
      CountryTranslation(countryId: 101, arName: 'الهند', enName: 'India'),
      CountryTranslation(
        countryId: 102,
        arName: 'إندونيسيا',
        enName: 'Indonesia',
      ),
      CountryTranslation(countryId: 109, arName: 'اليابان', enName: 'Japan'),
      CountryTranslation(
        countryId: 116,
        arName: 'كوريا الجنوبية',
        enName: 'South Korea',
      ),
      CountryTranslation(
        countryId: 115,
        arName: 'كوريا الشمالية',
        enName: 'North Korea',
      ),
      CountryTranslation(countryId: 44, arName: 'الصين', enName: 'China'),
      CountryTranslation(countryId: 132, arName: 'ماليزيا', enName: 'Malaysia'),
      CountryTranslation(
        countryId: 196,
        arName: 'سنغافورة',
        enName: 'Singapore',
      ),
      CountryTranslation(countryId: 217, arName: 'تايلاند', enName: 'Thailand'),
      CountryTranslation(
        countryId: 173,
        arName: 'الفلبين',
        enName: 'Philippines',
      ),
      CountryTranslation(countryId: 150, arName: 'ميانمار', enName: 'Myanmar'),
      CountryTranslation(countryId: 36, arName: 'كمبوديا', enName: 'Cambodia'),
      CountryTranslation(countryId: 119, arName: 'لاوس', enName: 'Laos'),
      CountryTranslation(countryId: 238, arName: 'فيتنام', enName: 'Vietnam'),
      CountryTranslation(
        countryId: 13,
        arName: 'أستراليا',
        enName: 'Australia',
      ),
      CountryTranslation(
        countryId: 157,
        arName: 'نيوزيلندا',
        enName: 'New Zealand',
      ),
      CountryTranslation(countryId: 30, arName: 'البرازيل', enName: 'Brazil'),
      CountryTranslation(countryId: 43, arName: 'تشيلي', enName: 'Chile'),
      CountryTranslation(countryId: 47, arName: 'كولومبيا', enName: 'Colombia'),
      CountryTranslation(countryId: 172, arName: 'بيرو', enName: 'Peru'),
      CountryTranslation(countryId: 142, arName: 'المكسيك', enName: 'Mexico'),
      CountryTranslation(countryId: 169, arName: 'بنما', enName: 'Panama'),
      CountryTranslation(countryId: 26, arName: 'بوليفيا', enName: 'Bolivia'),
      CountryTranslation(countryId: 63, arName: 'الإكوادور', enName: 'Ecuador'),
      CountryTranslation(
        countryId: 171,
        arName: 'باراغواي',
        enName: 'Paraguay',
      ),
      CountryTranslation(countryId: 233, arName: 'أوروغواي', enName: 'Uruguay'),
      CountryTranslation(
        countryId: 237,
        arName: 'فنزويلا',
        enName: 'Venezuela',
      ),
      CountryTranslation(
        countryId: 10,
        arName: 'الأرجنتين',
        enName: 'Argentina',
      ),
      CountryTranslation(
        countryId: 202,
        arName: 'جنوب أفريقيا',
        enName: 'South Africa',
      ),
      CountryTranslation(countryId: 113, arName: 'كينيا', enName: 'Kenya'),
      CountryTranslation(countryId: 160, arName: 'نيجيريا', enName: 'Nigeria'),
      CountryTranslation(countryId: 83, arName: 'غانا', enName: 'Ghana'),
      CountryTranslation(countryId: 148, arName: 'المغرب', enName: 'Morocco'),
      CountryTranslation(countryId: 222, arName: 'تونس', enName: 'Tunisia'),
      CountryTranslation(countryId: 124, arName: 'ليبيا', enName: 'Libya'),
      CountryTranslation(countryId: 243, arName: 'اليمن', enName: 'Yemen'),
      CountryTranslation(countryId: 201, arName: 'الصومال', enName: 'Somalia'),
      CountryTranslation(countryId: 216, arName: 'تنزانيا', enName: 'Tanzania'),
      CountryTranslation(countryId: 182, arName: 'رواندا', enName: 'Rwanda'),
      CountryTranslation(
        countryId: 149,
        arName: 'موزمبيق',
        enName: 'Mozambique',
      ),
      CountryTranslation(countryId: 131, arName: 'مالاوي', enName: 'Malawi'),
      CountryTranslation(
        countryId: 130,
        arName: 'مدغشقر',
        enName: 'Madagascar',
      ),
      CountryTranslation(
        countryId: 140,
        arName: 'موريشيوس',
        enName: 'Mauritius',
      ),
      CountryTranslation(countryId: 194, arName: 'سيشل', enName: 'Seychelles'),
      CountryTranslation(
        countryId: 195,
        arName: 'سيراليون',
        enName: 'Sierra Leone',
      ),
      CountryTranslation(countryId: 123, arName: 'ليبيريا', enName: 'Liberia'),
      CountryTranslation(countryId: 192, arName: 'السنغال', enName: 'Senegal'),
      CountryTranslation(
        countryId: 139,
        arName: 'موريتانيا',
        enName: 'Mauritania',
      ),
      CountryTranslation(
        countryId: 34,
        arName: 'بوركينا فاسو',
        enName: 'Burkina Faso',
      ),
      CountryTranslation(countryId: 35, arName: 'بوروندي', enName: 'Burundi'),
      CountryTranslation(countryId: 23, arName: 'بنين', enName: 'Benin'),
      CountryTranslation(countryId: 79, arName: 'الغابون', enName: 'Gabon'),
      CountryTranslation(countryId: 49, arName: 'الكونغو', enName: 'Congo'),
      CountryTranslation(
        countryId: 50,
        arName: 'جمهورية الكونغو الديمقراطية',
        enName: 'Democratic Republic of Congo',
      ),
      CountryTranslation(countryId: 159, arName: 'النيجر', enName: 'Niger'),
      CountryTranslation(countryId: 134, arName: 'مالي', enName: 'Mali'),
      CountryTranslation(countryId: 42, arName: 'تشاد', enName: 'Chad'),
      CountryTranslation(
        countryId: 41,
        arName: 'جمهورية أفريقيا الوسطى',
        enName: 'Central African Republic',
      ),
      CountryTranslation(
        countryId: 37,
        arName: 'الكاميرون',
        enName: 'Cameroon',
      ),
      CountryTranslation(
        countryId: 66,
        arName: 'غينيا الاستوائية',
        enName: 'Equatorial Guinea',
      ),
      CountryTranslation(countryId: 92, arName: 'غينيا', enName: 'Guinea'),
      CountryTranslation(
        countryId: 93,
        arName: 'غينيا بيساو',
        enName: 'Guinea-Bissau',
      ),
      CountryTranslation(countryId: 95, arName: 'هايتي', enName: 'Haiti'),
      CountryTranslation(countryId: 97, arName: 'هندوراس', enName: 'Honduras'),
      CountryTranslation(
        countryId: 90,
        arName: 'غواتيمالا',
        enName: 'Guatemala',
      ),
      CountryTranslation(
        countryId: 65,
        arName: 'السلفادور',
        enName: 'El Salvador',
      ),
      CountryTranslation(
        countryId: 158,
        arName: 'نيكاراغوا',
        enName: 'Nicaragua',
      ),
      CountryTranslation(
        countryId: 52,
        arName: 'كوستا ريكا',
        enName: 'Costa Rica',
      ),
      CountryTranslation(countryId: 108, arName: 'جامايكا', enName: 'Jamaica'),
      CountryTranslation(
        countryId: 61,
        arName: 'جمهورية الدومينيكان',
        enName: 'Dominican Republic',
      ),
      CountryTranslation(countryId: 60, arName: 'دومينيكا', enName: 'Dominica'),
      CountryTranslation(countryId: 87, arName: 'غرينادا', enName: 'Grenada'),
      CountryTranslation(
        countryId: 9,
        arName: 'أنتيغوا وباربودا',
        enName: 'Antigua and Barbuda',
      ),
      CountryTranslation(
        countryId: 187,
        arName: 'سانت فنسنت وجزر غرينادين',
        enName: 'Saint Vincent and the Grenadines',
      ),
      CountryTranslation(
        countryId: 185,
        arName: 'سانت لوسيا',
        enName: 'Saint Lucia',
      ),
      CountryTranslation(
        countryId: 184,
        arName: 'سانت كيتس ونيفيس',
        enName: 'Saint Kitts and Nevis',
      ),
      CountryTranslation(countryId: 188, arName: 'ساموا', enName: 'Samoa'),
      CountryTranslation(countryId: 220, arName: 'تونغا', enName: 'Tonga'),
      CountryTranslation(countryId: 235, arName: 'فانواتو', enName: 'Vanuatu'),
      CountryTranslation(
        countryId: 200,
        arName: 'جزر سليمان',
        enName: 'Solomon Islands',
      ),
      CountryTranslation(
        countryId: 170,
        arName: 'بابوا غينيا الجديدة',
        enName: 'Papua New Guinea',
      ),
      CountryTranslation(countryId: 73, arName: 'فيجي', enName: 'Fiji'),
      CountryTranslation(
        countryId: 114,
        arName: 'كيريباتي',
        enName: 'Kiribati',
      ),
      CountryTranslation(countryId: 152, arName: 'ناورو', enName: 'Nauru'),
      CountryTranslation(countryId: 226, arName: 'توفالو', enName: 'Tuvalu'),
      CountryTranslation(
        countryId: 51,
        arName: 'جزر كوك',
        enName: 'Cook Islands',
      ),
      CountryTranslation(countryId: 161, arName: 'نيوي', enName: 'Niue'),
      CountryTranslation(
        countryId: 162,
        arName: 'جزيرة نورفولك',
        enName: 'Norfolk Island',
      ),
      CountryTranslation(
        countryId: 45,
        arName: 'جزيرة الكريسماس',
        enName: 'Christmas Island',
      ),
      CountryTranslation(
        countryId: 46,
        arName: 'جزر كوكوس',
        enName: 'Cocos Islands',
      ),
      CountryTranslation(
        countryId: 156,
        arName: 'كاليدونيا الجديدة',
        enName: 'New Caledonia',
      ),
      CountryTranslation(countryId: 179, arName: 'ريونيون', enName: 'Réunion'),
      CountryTranslation(countryId: 141, arName: 'مايوت', enName: 'Mayotte'),
      CountryTranslation(
        countryId: 88,
        arName: 'غوادلوب',
        enName: 'Guadeloupe',
      ),
      CountryTranslation(
        countryId: 138,
        arName: 'مارتينيك',
        enName: 'Martinique',
      ),
      CountryTranslation(
        countryId: 78,
        arName: 'الأراضي الفرنسية الجنوبية',
        enName: 'French Southern Territories',
      ),
      CountryTranslation(
        countryId: 76,
        arName: 'غويانا الفرنسية',
        enName: 'French Guiana',
      ),
      CountryTranslation(
        countryId: 77,
        arName: 'بولينيزيا الفرنسية',
        enName: 'French Polynesia',
      ),
      CountryTranslation(
        countryId: 241,
        arName: 'واليس وفوتونا',
        enName: 'Wallis and Futuna',
      ),
      CountryTranslation(
        countryId: 186,
        arName: 'سانت بيير وميكلون',
        enName: 'Saint Pierre and Miquelon',
      ),
      CountryTranslation(
        countryId: 183,
        arName: 'سانت هيلينا',
        enName: 'Saint Helena',
      ),
      CountryTranslation(
        countryId: 174,
        arName: 'جزيرة بيتكيرن',
        enName: 'Pitcairn Island',
      ),
      CountryTranslation(
        countryId: 189,
        arName: 'سان مارينو',
        enName: 'San Marino',
      ),
      CountryTranslation(
        countryId: 125,
        arName: 'ليختنشتاين',
        enName: 'Liechtenstein',
      ),
      CountryTranslation(countryId: 145, arName: 'موناكو', enName: 'Monaco'),
      CountryTranslation(
        countryId: 236,
        arName: 'الفاتيكان',
        enName: 'Vatican City',
      ),
      CountryTranslation(
        countryId: 4,
        arName: 'ساموا الأمريكية',
        enName: 'American Samoa',
      ),
      CountryTranslation(countryId: 89, arName: 'غوام', enName: 'Guam'),
      CountryTranslation(
        countryId: 163,
        arName: 'جزر ماريانا الشمالية',
        enName: 'Northern Mariana Islands',
      ),
      CountryTranslation(
        countryId: 177,
        arName: 'بورتوريكو',
        enName: 'Puerto Rico',
      ),
      CountryTranslation(
        countryId: 239,
        arName: 'جزر العذراء البريطانية',
        enName: 'British Virgin Islands',
      ),
      CountryTranslation(
        countryId: 240,
        arName: 'جزر العذراء الأمريكية',
        enName: 'US Virgin Islands',
      ),
      CountryTranslation(
        countryId: 225,
        arName: 'جزر تركس وكايكوس',
        enName: 'Turks and Caicos Islands',
      ),
      CountryTranslation(countryId: 24, arName: 'برمودا', enName: 'Bermuda'),
      CountryTranslation(
        countryId: 84,
        arName: 'جبل طارق',
        enName: 'Gibraltar',
      ),
      CountryTranslation(
        countryId: 91,
        arName: 'غيرنزي وألدرني',
        enName: 'Guernsey and Alderney',
      ),
      CountryTranslation(countryId: 110, arName: 'جيرسي', enName: 'Jersey'),
      CountryTranslation(
        countryId: 136,
        arName: 'جزيرة مان',
        enName: 'Isle of Man',
      ),
      CountryTranslation(
        countryId: 199,
        arName: 'أقاليم المملكة المتحدة الأصغر',
        enName: 'Smaller UK Territories',
      ),
      CountryTranslation(
        countryId: 31,
        arName: 'إقليم المحيط الهندي البريطاني',
        enName: 'British Indian Ocean Territory',
      ),
      CountryTranslation(
        countryId: 203,
        arName: 'جورجيا الجنوبية',
        enName: 'South Georgia',
      ),
      CountryTranslation(
        countryId: 71,
        arName: 'جزر فوكلاند',
        enName: 'Falkland Islands',
      ),
      CountryTranslation(
        countryId: 96,
        arName: 'جزر هيرد وماكدونالد',
        enName: 'Heard and McDonald Islands',
      ),
      CountryTranslation(
        countryId: 29,
        arName: 'جزيرة بوفيه',
        enName: 'Bouvet Island',
      ),
      CountryTranslation(
        countryId: 209,
        arName: 'سفالبارد وجان ماين',
        enName: 'Svalbard and Jan Mayen',
      ),
      CountryTranslation(
        countryId: 8,
        arName: 'أنتاركتيكا',
        enName: 'Antarctica',
      ),
      CountryTranslation(
        countryId: 242,
        arName: 'الصحراء الغربية',
        enName: 'Western Sahara',
      ),
      CountryTranslation(
        countryId: 204,
        arName: 'جنوب السودان',
        enName: 'South Sudan',
      ),
      CountryTranslation(countryId: 207, arName: 'السودان', enName: 'Sudan'),
      CountryTranslation(countryId: 67, arName: 'إريتريا', enName: 'Eritrea'),
      CountryTranslation(countryId: 69, arName: 'إثيوبيا', enName: 'Ethiopia'),
      CountryTranslation(countryId: 218, arName: 'توغو', enName: 'Togo'),
      CountryTranslation(countryId: 48, arName: 'جزر القمر', enName: 'Comoros'),
      CountryTranslation(
        countryId: 133,
        arName: 'جزر المالديف',
        enName: 'Maldives',
      ),
      CountryTranslation(countryId: 32, arName: 'بروناي', enName: 'Brunei'),
      CountryTranslation(
        countryId: 98,
        arName: 'هونغ كونغ',
        enName: 'Hong Kong',
      ),
      CountryTranslation(countryId: 128, arName: 'ماكاو', enName: 'Macau'),
      CountryTranslation(countryId: 214, arName: 'تايوان', enName: 'Taiwan'),
      CountryTranslation(
        countryId: 62,
        arName: 'تيمور الشرقية',
        enName: 'East Timor',
      ),
      CountryTranslation(
        countryId: 18,
        arName: 'بنغلاديش',
        enName: 'Bangladesh',
      ),
      CountryTranslation(countryId: 153, arName: 'نيبال', enName: 'Nepal'),
      CountryTranslation(countryId: 25, arName: 'بوتان', enName: 'Bhutan'),
      CountryTranslation(countryId: 134, arName: 'مالي', enName: 'Mali'),
      CountryTranslation(countryId: 135, arName: 'مالطا', enName: 'Malta'),
      CountryTranslation(
        countryId: 137,
        arName: 'جزر مارشال',
        enName: 'Marshall Islands',
      ),
      CountryTranslation(
        countryId: 143,
        arName: 'ميكرونيزيا',
        enName: 'Micronesia',
      ),
      CountryTranslation(countryId: 144, arName: 'مولدوفا', enName: 'Moldova'),
      CountryTranslation(countryId: 146, arName: 'منغوليا', enName: 'Mongolia'),
      CountryTranslation(
        countryId: 147,
        arName: 'مونتسيرات',
        enName: 'Montserrat',
      ),
      CountryTranslation(
        countryId: 190,
        arName: 'ساو تومي وبرينسيبي',
        enName: 'São Tomé and Príncipe',
      ),
      CountryTranslation(
        countryId: 210,
        arName: 'إسواتيني',
        enName: 'Eswatini',
      ),
      CountryTranslation(countryId: 122, arName: 'ليسوتو', enName: 'Lesotho'),
      CountryTranslation(countryId: 219, arName: 'توكيلاو', enName: 'Tokelau'),
    ];

    for (final translation in fallbackTranslations) {
      await _translationsBox!.put(translation.countryId, translation);
    }
  }

  // Get all countries
  static List<Country> getAllCountries() {
    return _cachedCountries;
  }

  // Get country by ID
  static Country? getCountryById(int id) {
    return _cachedCountries.firstWhere(
      (country) => country.id == id,
      orElse: () => _cachedCountries.first,
    );
  }

  // Get localized country name
  static String getLocalizedCountryName(int countryId, Locale locale) {
    final translation = _cachedTranslations[countryId];
    if (translation == null) {
      // Fallback to English name from country data
      final country = getCountryById(countryId);
      return country?.name ?? 'Unknown Country';
    }

    return locale.languageCode == 'ar'
        ? translation.arName
        : translation.enName;
  }

  // Search countries by name
  static List<Country> searchCountries(String query, Locale locale) {
    if (query.isEmpty) return _cachedCountries;

    final lowercaseQuery = query.toLowerCase();
    return _cachedCountries.where((country) {
      final translation = _cachedTranslations[country.id];
      if (translation != null) {
        final localizedName =
            locale.languageCode == 'ar'
                ? translation.arName
                : translation.enName;
        return localizedName.toLowerCase().contains(lowercaseQuery);
      }
      return country.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get popular countries (commonly used)
  static List<Country> getPopularCountries() {
    const popularCountryIds = [
      165,
      191,
      229,
      64,
      117,
      178,
      17,
      111,
      121,
      231,
      230,
      38,
    ];
    return popularCountryIds
        .map((id) => getCountryById(id))
        .where((country) => country != null)
        .cast<Country>()
        .toList();
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await _countriesBox?.clear();
    await _translationsBox?.clear();
    _cachedCountries.clear();
    _cachedTranslations.clear();
    await _loadInitialData();
  }

  // Close boxes
  static Future<void> dispose() async {
    await _countriesBox?.close();
    await _translationsBox?.close();
  }
}

/// Country translation model
@HiveType(typeId: 4)
class CountryTranslation extends Equatable {
  @HiveField(0)
  final int countryId;

  @HiveField(1)
  final String arName;

  @HiveField(2)
  final String enName;

  const CountryTranslation({
    required this.countryId,
    required this.arName,
    required this.enName,
  });

  factory CountryTranslation.fromJson(Map<String, dynamic> json) {
    return CountryTranslation(
      countryId: json['country_id'] ?? 0,
      arName: json['ar_name'] ?? '',
      enName: json['en_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'country_id': countryId, 'ar_name': arName, 'en_name': enName};
  }

  @override
  List<Object?> get props => [countryId, arName, enName];
}

/// Country translation adapter for Hive
class CountryTranslationAdapter extends TypeAdapter<CountryTranslation> {
  @override
  final int typeId = 4;

  @override
  CountryTranslation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryTranslation(
      countryId: fields[0] as int,
      arName: fields[1] as String,
      enName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CountryTranslation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.countryId)
      ..writeByte(1)
      ..write(obj.arName)
      ..writeByte(2)
      ..write(obj.enName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryTranslationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
