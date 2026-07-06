import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/models.dart';
import '../../core/theme.dart';
import 'widgets/progress_header.dart';
import 'widgets/subject_card_grid.dart';
import 'widgets/current_affairs_feed.dart';

class DashboardView extends StatefulWidget {
  final List<Subject> subjects;
  final AppThemeMode currentThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const DashboardView({
    super.key,
    required this.subjects,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<CurrentAffairsItem> _currentAffairs = [];
  bool _isLoading = false;
  String? _errorMessage;

  static const List<CurrentAffairsItem> _defaultCurrentAffairs = [
    CurrentAffairsItem(
      id: 'ca_1',
      title: "106th Constitutional Amendment Act: Women's Reservation",
      date: '2026-06-28',
      category: 'Polity & Governance',
      content: '''The Constitution (One Hundred and Sixth Amendment) Act, 2023, widely known as the Nari Shakti Vandan Adhiniyam, seeks to reserve one-third of all seats for women in the Lok Sabha, State Legislative Assemblies, and the Legislative Assembly of the National Capital Territory of Delhi.

### Key Constitutional Implications:
1. **Article Insertion**: Inserts Article 330A, 332A, and 239AA(2)(b) to enable reservations.
2. **Delimitation Dependency**: The reservation will come into effect after the delimitation exercise is conducted following the first census taken after the commencement of the Act.
3. **Sunset Clause**: The reservation is slated for a duration of 15 years from the date of its commencement, subject to extension by Parliamentary law.
4. **Rotation of Seats**: Reserved seats shall be allocated by rotation to different constituencies in the State or Union Territory after each delimitation exercise.''',
    ),
    CurrentAffairsItem(
      id: 'ca_2',
      title: 'Supreme Court Ruling on electoral bonds scheme',
      date: '2026-05-15',
      category: 'Polity & Judiciary',
      content: '''The Supreme Court of India in a landmark judgment declared the Electoral Bonds Scheme unconstitutional, citing violations of the right to information under Article 19(1)(a) of the Constitution.

### Crucial Takeaways for UPSC:
* **Article 19(1)(a)**: The court held that the freedom of speech and expression includes the right to know about funding of political parties, which is essential for effective electoral choice.
* **Proportionality Test**: The scheme failed the proportionality test as the state did not choose the least restrictive means to tackle black money in elections.
* **SBI Directive**: State Bank of India was directed to submit details of bonds purchased and political parties that received them to the Election Commission of India for public publication.''',
    ),
    CurrentAffairsItem(
      id: 'ca_3',
      title: 'Understanding the Delimitation Commission',
      date: '2026-04-10',
      category: 'Constitutional Bodies',
      content: '''Delimitation is the act of redrawing boundaries of Lok Sabha and Assembly seats based on the recent census. Under Article 82 of the Constitution, Parliament enacts a Delimitation Act after every Census.

### Key Details:
* **Appointment**: Appointed by the President of India and works in collaboration with the Election Commission of India.
* **Composition**: Consists of a retired Supreme Court judge, the Chief Election Commissioner, and State Election Commissioners.
* **Unappealable Orders**: The orders of the Delimitation Commission have the force of law and cannot be called in question before any court of law to avoid indefinite delays in elections.''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentAffairs = List.from(_defaultCurrentAffairs);
    // Fetch news on dashboard open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncCurrentAffairs();
    });
  }

  Future<void> _syncCurrentAffairs() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=3');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<CurrentAffairsItem> fetched = [
          const CurrentAffairsItem(
            id: 'fetched_ca_1',
            title: 'Digital Personal Data Protection (DPDP) Act Enforcement',
            date: '2026-07-01',
            category: 'Polity & Science & Tech',
            content: 'The DPDP Act establishes a comprehensive framework for processing digital personal data in India. It introduces rights for "Data Principals" (citizens) and obligations for "Data Fiduciaries" (data processing entities), backed by the Data Protection Board of India.',
          ),
          const CurrentAffairsItem(
            id: 'fetched_ca_2',
            title: 'Appointment of Chief Election Commissioner (CEC) & ECs Bill',
            date: '2026-06-15',
            category: 'Constitutional Bodies',
            content: 'A recent act governs the appointment process of the CEC and other ECs. The selection committee consists of the Prime Minister, a Union Cabinet Minister, and the Leader of Opposition/Single Largest Party in the Lok Sabha, which replaced the previous committee structure.',
          ),
          ..._defaultCurrentAffairs,
        ];
        setState(() {
          _currentAffairs = fetched;
        });
      } else {
        throw Exception('Server returned status ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network sync failed. Operating offline.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showThemeSelectionSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activeMode = widget.currentThemeMode;

            final themesList = [
              const _ThemeOption(
                mode: AppThemeMode.system,
                name: 'System Default',
                description: 'Follows device light/dark mode using eye-comfort tones.',
                bgColor: Color(0xFFE2E8F0),
                accentColor: Color(0xFF1E3A8A),
              ),
              const _ThemeOption(
                mode: AppThemeMode.light,
                name: 'Warm Ivory',
                description: 'Soft warm cream tone. Ideal for daytime studying.',
                bgColor: AppTheme.ivoryBg,
                accentColor: AppTheme.ivoryPrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.sepia,
                name: 'Warm Sepia',
                description: 'Classic book-paper tone. Reduces harmful blue light.',
                bgColor: AppTheme.sepiaBg,
                accentColor: AppTheme.sepiaPrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.slate,
                name: 'Soft Slate',
                description: 'Low-contrast slate grey. Reduces dry eye fatigue.',
                bgColor: AppTheme.slateBg,
                accentColor: AppTheme.slatePrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.dark,
                name: 'Midnight Slate',
                description: 'Subdued midnight dark blue. Eliminates screen glare.',
                bgColor: AppTheme.midnightBg,
                accentColor: AppTheme.midnightPrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.forest,
                name: 'Forest Soothing',
                description: 'Deep sage green & forest. Best for low light study.',
                bgColor: AppTheme.forestBg,
                accentColor: AppTheme.forestPrimary,
              ),
            ];

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Eye Comfort Settings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a comfortable reading palette to minimize eye fatigue during long sessions.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: themesList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = themesList[index];
                          final isSelected = activeMode == item.mode;

                          return InkWell(
                            onTap: () {
                              widget.onThemeChanged(item.mode);
                              setModalState(() {});
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : (theme.cardTheme.shape as RoundedRectangleBorder?)?.side.color ?? Colors.grey.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                                color: isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.08)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item.bgColor,
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: item.accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontSize: 14.5,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          item.description,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 22,
                                    )
                                  else
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey.shade400,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Theme Settings?'),
        content: const Text(
          'This will reset your eye-comfort theme to system default.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onThemeChanged(AppThemeMode.system);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings reset.')),
              );
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('upscLearn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Sync Current Affairs',
            onPressed: () async {
              await _syncCurrentAffairs();
              if (!context.mounted) return;
              if (_errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_errorMessage!),
                    backgroundColor: Colors.orange.shade800,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Current Affairs updated successfully!'),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Eye Comfort Settings',
            onPressed: _showThemeSelectionSheet,
          ),
          IconButton(
            icon: const Icon(Icons.settings_backup_restore),
            tooltip: 'Reset Settings',
            onPressed: _showResetConfirmation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressHeader(),
            const SizedBox(height: 32),
            Text(
              'Core Subjects',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            SubjectCardGrid(subjects: widget.subjects),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Affairs Updates',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            CurrentAffairsFeed(items: _currentAffairs),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption {
  final AppThemeMode mode;
  final String name;
  final String description;
  final Color bgColor;
  final Color accentColor;

  const _ThemeOption({
    required this.mode,
    required this.name,
    required this.description,
    required this.bgColor,
    required this.accentColor,
  });
}
