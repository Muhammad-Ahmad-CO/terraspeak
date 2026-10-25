import 'package:flutter/material.dart';

void main() {
  runApp(const TerraSpeakApp());
}

class TerraSpeakApp extends StatefulWidget {
  const TerraSpeakApp({super.key});

  @override
  State<TerraSpeakApp> createState() => _TerraSpeakAppState();
}

class _TerraSpeakAppState extends State<TerraSpeakApp> {
  String lang = 'en';
  String area = 'Hyderabad';
  String crop = 'Wheat';
  String problem = 'Whitefly';

  String t(String key) {
    return _texts[lang]?[key] ?? _texts['en']![key]!;
  }

  List<String> _adviceTips() {
    if (crop == 'Wheat') {
      if (lang == 'ur') {
        return [
          'Is hafte zameen me nami check karo, zyada pani mat do.',
          'Beej ki ugao dekho, khali jagah par dobara beej lagao.',
          'Khad sirf zaroorat par do, zyada khad fasal ko nuqsan de sakti hai.',
        ];
      }
      return [
        'Check soil moisture this week, do not overwater.',
        'Check seed growth, reseed empty spots if needed.',
        'Use fertilizer only when needed, too much can harm the crop.',
      ];
    }
    if (lang == 'ur') {
      return [
        'Kapas ke patton par safed makhi roz check karo.',
        'Pani waqt par do, khait me pani khara mat hone do.',
        'Spray se pehle bottle ka label zaroor parho.',
      ];
    }
    return [
      'Check cotton leaves daily for whitefly.',
      'Water on time, do not let water stand in the field.',
      'Before any spray, always read the bottle label.',
    ];
  }

  String _guidance() {
    if (problem == 'Whitefly') {
      if (lang == 'ur') {
        return 'Patton ke neeche safed makhi check karo. Pehle haath se aur pani se saaf karne ki koshish karo. Dawa lene se pehle bottle ka label parho aur maqami agriculture officer se confirm karo.';
      }
      return 'Check under the leaves for whitefly. Try cleaning by hand and water first. Before any chemical, read the bottle label and confirm with your local agriculture officer.';
    }
    if (problem == 'Wheat Seed') {
      if (lang == 'ur') {
        return 'Achha beej lo, purana ya kharab beej mat lagao. Bijai se pehle zameen tayyar karo aur beej ki miqdar apne ilaqe ke hisab se rakho.';
      }
      return 'Use good quality seed, do not sow old or damaged seed. Prepare the soil before sowing and use the seed rate for your area.';
    }
    if (lang == 'ur') {
      return 'Pani waqt par do, lekin zyada pani se zameen kharab hoti hai. Subah ya shaam ko pani dena behtar hota hai.';
    }
    return 'Water on time, but too much water harms the soil. Morning or evening watering is usually better.';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TerraSpeak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(t('title')),
          backgroundColor: const Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              tooltip: 'Language',
              onSelected: (value) {
                setState(() {
                  lang = value;
                });
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'ur', child: Text('Roman Urdu')),
                PopupMenuItem(value: 'sd', child: Text('Sindhi')),
                PopupMenuItem(value: 'pa', child: Text('Punjabi')),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t('tagline'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _card(
                title: t('profile'),
                children: [
                  DropdownButton<String>(
                    value: area,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Hyderabad', child: Text('Hyderabad')),
                      DropdownMenuItem(value: 'Karachi', child: Text('Karachi')),
                      DropdownMenuItem(value: 'Sukkur', child: Text('Sukkur')),
                      DropdownMenuItem(value: 'Lahore', child: Text('Lahore')),
                      DropdownMenuItem(value: 'Multan', child: Text('Multan')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          area = value;
                        });
                      }
                    },
                  ),
                  DropdownButton<String>(
                    value: crop,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Wheat', child: Text('Wheat / Gandum')),
                      DropdownMenuItem(value: 'Cotton', child: Text('Cotton / Kapas')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          crop = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t('saved'))),
                        );
                      },
                      child: Text(t('save')),
                    ),
                  ),
                ],
              ),
              _card(
                title: t('advice'),
                children: [
                  Text('$area - $crop'),
                  const SizedBox(height: 8),
                  for (final tip in _adviceTips())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('• $tip'),
                    ),
                ],
              ),
              _card(
                title: t('problem'),
                children: [
                  DropdownButton<String>(
                    value: problem,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Whitefly', child: Text('Whitefly')),
                      DropdownMenuItem(value: 'Wheat Seed', child: Text('Wheat Seed')),
                      DropdownMenuItem(value: 'Water', child: Text('Water')),
                      DropdownMenuItem(value: 'Fertilizer', child: Text('Fertilizer')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          problem = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(problem),
                              content: Text(_guidance()),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(t('guidance')),
                    ),
                  ),
                ],
              ),
              _card(
                title: t('mandi'),
                children: [
                  const ListTile(
                    title: Text('Wheat'),
                    subtitle: Text('Demo only - not a live rate'),
                    trailing: Text('Rs 2800 / 40kg'),
                  ),
                  const ListTile(
                    title: Text('Cotton'),
                    subtitle: Text('Demo only - not a live rate'),
                    trailing: Text('Rs 7500 / 40kg'),
                  ),
                ],
              ),
              _card(
                title: t('words'),
                children: const [
                  Text('Wheat - Gandum'),
                  Text('Cotton - Kapas'),
                  Text('Water - Pani'),
                  Text('Seed - Beej'),
                  Text('Soil - Mitti'),
                ],
              ),
              _card(
                title: t('agent'),
                children: [
                  Text(t('agentNote')),
                ],
              ),
              Text(
                t('footer'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

const Map<String, Map<String, String>> _texts = {
  'en': {
    'title': 'TerraSpeak',
    'tagline': "Farming in every farmer's own language.",
    'profile': 'Farmer Profile',
    'advice': 'Weekly Advice',
    'problem': 'Ask a Problem',
    'mandi': 'Mandi Rates',
    'words': 'Farming Words',
    'agent': 'Village Agent',
    'save': 'Save Profile',
    'saved': 'Profile saved.',
    'guidance': 'Get Guidance',
    'agentNote': 'A village agent can help 15 to 20 farmers enter their details.',
    'footer': 'TerraSpeak - Demo data only.',
  },
  'ur': {
    'title': 'TerraSpeak',
    'tagline': 'Har kisan ki apni zaban me kheti.',
    'profile': 'Kisan Profile',
    'advice': 'Haftawar Mashwara',
    'problem': 'Masla Poochna',
    'mandi': 'Mandi Rate',
    'words': 'Kheti ke Lafz',
    'agent': 'Gaon Agent',
    'save': 'Profile Save Karo',
    'saved': 'Profile save ho gaya.',
    'guidance': 'Mashwara Lo',
    'agentNote': 'Gaon agent 15 se 20 kisano ki madad kar sakta hai.',
    'footer': 'TerraSpeak - Sirf demo data hai.',
  },
  'sd': {
    'title': 'TerraSpeak',
    'tagline': 'Har kisan ji panji boli me kheti.',
    'profile': 'Kisan Profile',
    'advice': 'Haftawar Mashwaro',
    'problem': 'Maslo Poochna',
    'mandi': 'Mandi Rate',
    'words': 'Kheti ja Lafz',
    'agent': 'Gaon Agent',
    'save': 'Profile Save Karo',
    'saved': 'Profile save thi wayo.',
    'guidance': 'Mashwaro Watho',
    'agentNote': 'Gaon agent 15 te 20 kisanan ji madad kare saghe tho.',
    'footer': 'TerraSpeak - Sirf demo data ahe.',
  },
  'pa': {
    'title': 'TerraSpeak',
    'tagline': 'Har kisan nu apni boli vich kheti.',
    'profile': 'Kisan Profile',
    'advice': 'Haftawar Mashwara',
    'problem': 'Masla Poochna',
    'mandi': 'Mandi Rate',
    'words': 'Kheti de Lafz',
    'agent': 'Gaon Agent',
    'save': 'Profile Save Karo',
    'saved': 'Profile save ho gaya.',
    'guidance': 'Mashwara Lao',
    'agentNote': 'Gaon agent 15 to 20 kisana di madad kar sakda hai.',
    'footer': 'TerraSpeak - Sirf demo data hai.',
  },
};
