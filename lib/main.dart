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
  String farmerName = '';
  DateTime? sowingDate;
  bool profileSaved = false;
  String search = '';
  String agentName = '';
  String agentCrop = 'Wheat';
  final List<String> agentFarmers = [];
  final TextEditingController agentController = TextEditingController();

  @override
  void dispose() {
    agentController.dispose();
    super.dispose();
  }

  String t(String key) {
    return _texts[lang]?[key] ?? _texts['en']![key]!;
  }

  String _fmt(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  List<_Stage> _stages() {
    final s = sowingDate!;
    if (crop == 'Wheat') {
      return [
        _Stage('Sowing', s, s.add(const Duration(days: 6))),
        _Stage('Germination', s.add(const Duration(days: 7)), s.add(const Duration(days: 14))),
        _Stage('Tillering', s.add(const Duration(days: 21)), s.add(const Duration(days: 45))),
        _Stage('Stem Growth', s.add(const Duration(days: 46)), s.add(const Duration(days: 75))),
        _Stage('Flowering', s.add(const Duration(days: 76)), s.add(const Duration(days: 100))),
        _Stage('Harvest', s.add(const Duration(days: 110)), s.add(const Duration(days: 130))),
      ];
    }
    return [
      _Stage('Sowing', s, s.add(const Duration(days: 6))),
      _Stage('Germination', s.add(const Duration(days: 7)), s.add(const Duration(days: 10))),
      _Stage('Squaring', s.add(const Duration(days: 35)), s.add(const Duration(days: 50))),
      _Stage('Flowering', s.add(const Duration(days: 50)), s.add(const Duration(days: 80))),
      _Stage('Boll Formation', s.add(const Duration(days: 80)), s.add(const Duration(days: 120))),
      _Stage('Picking', s.add(const Duration(days: 130)), s.add(const Duration(days: 160))),
    ];
  }

  String _currentStage() {
    if (sowingDate == null) return '-';
    final days = DateTime.now().difference(sowingDate!).inDays;
    if (days < 0) return 'Not sown yet';
    for (final st in _stages()) {
      final start = st.start.difference(sowingDate!).inDays;
      final end = st.end.difference(sowingDate!).inDays;
      if (days >= start && days <= end) return st.name;
    }
    return 'After harvest window - check field';
  }

  List<String> _adviceTips() {
    if (sowingDate != null) {
      final stage = _currentStage();
      if (lang == 'ur') {
        return [
          'Maujooda stage: $stage.',
          'Is stage me khait roz check karo, pani aur keere par nazar rakho.',
          'Koi dawa lene se pehle bottle ka label parho aur officer se confirm karo.',
        ];
      }
      return [
        'Current stage: $stage.',
        'Check the field daily in this stage, watch water and pests.',
        'Before any chemical, read the bottle label and confirm with an officer.',
      ];
    }
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

  List<String> _problemSteps() {
    final ur = lang == 'ur';
    switch (problem) {
      case 'Whitefly':
        return ur
            ? ['Patton ke neeche safed makhi check karo.', 'Pehele haath aur pani se saaf karne ki koshish karo.', 'Mutasir patte alag karo, khait saaf rakho.']
            : ['Check under the leaves for whitefly.', 'Try cleaning by hand and water first.', 'Remove affected leaves and keep the field clean.'];
      case 'Aphids':
        return ur
            ? ['Patton aur tanon par chote keere check karo.', 'Pani ke tez chidak se keere hatao.', 'Mutasir hisse ko alag karo.']
            : ['Check leaves and stems for small insects.', 'Wash them off with a strong spray of water.', 'Remove affected parts.'];
      case 'Wheat Rust':
        return ur
            ? ['Patton par narangi ya bhure dhabbe check karo.', 'Mutasir patte jama kar ke door phenko.', 'Agla qadam officer se pooch kar lo.']
            : ['Check leaves for orange or brown spots.', 'Collect affected leaves and dispose of them away from the field.', 'Ask an officer before the next step.'];
      case 'Cotton Bollworm':
        return ur
            ? ['Tindon me chhed aur keere check karo.', 'Mutasir tinde tor kar door karo.', 'Roz nigrani karo, dawa ka faisla officer se confirm karo.']
            : ['Check bolls for holes and larvae.', 'Remove affected bolls and dispose of them.', 'Monitor daily and confirm any chemical decision with an officer.'];
      case 'Water':
        return ur
            ? ['Zameen me nami ungli se check karo.', 'Subah ya shaam ko pani do.', 'Khait me pani khara mat hone do.']
            : ['Check soil moisture with your finger.', 'Water in the morning or evening.', 'Do not let water stand in the field.'];
      default:
        return ur
            ? ['Khad ki zaroorat zameen aur fasal dekh kar tay karo.', 'Zyada khad nuqsan de sakti hai.', 'Miqdar officer ya label se confirm karo.']
            : ['Decide fertilizer need from soil and crop condition.', 'Too much fertilizer can harm the crop.', 'Confirm the amount from the label or an officer.'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = _words.where((w) {
      if (search.isEmpty) return true;
      final q = search.toLowerCase();
      return w.$1.toLowerCase().contains(q) || w.$2.toLowerCase().contains(q);
    }).toList();
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
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Farmer name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => farmerName = v,
                  ),
                  const SizedBox(height: 12),
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
                      if (value != null) setState(() => area = value);
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
                      if (value != null) setState(() => crop = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sowingDate == null
                              ? 'Sowing date: not set'
                              : 'Sowing date: ${_fmt(sowingDate!)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => sowingDate = picked);
                          }
                        },
                        child: const Text('Pick date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => profileSaved = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t('saved'))),
                        );
                      },
                      child: Text(t('save')),
                    ),
                  ),
                  if (profileSaved)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('$farmerName - $area - $crop'),
                    ),
                ],
              ),
              if (sowingDate != null)
                _card(
                  title: t('calendar'),
                  children: [
                    Text('Current stage: ${_currentStage()}'),
                    const SizedBox(height: 8),
                    for (final st in _stages())
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('${st.name}: ${_fmt(st.start)} to ${_fmt(st.end)}'),
                      ),
                    const SizedBox(height: 8),
                    Text(t('calendarNote')),
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
                      DropdownMenuItem(value: 'Aphids', child: Text('Aphids')),
                      DropdownMenuItem(value: 'Wheat Rust', child: Text('Wheat Rust')),
                      DropdownMenuItem(value: 'Cotton Bollworm', child: Text('Cotton Bollworm')),
                      DropdownMenuItem(value: 'Water', child: Text('Water')),
                      DropdownMenuItem(value: 'Fertilizer', child: Text('Fertilizer')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => problem = value);
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
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (var i = 0; i < _problemSteps().length; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Text('${i + 1}. ${_problemSteps()[i]}'),
                                      ),
                                    const SizedBox(height: 8),
                                    Text(t('safety')),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
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
                children: const [
                  ListTile(
                    title: Text('Wheat'),
                    subtitle: Text('Demo only - not a live rate'),
                    trailing: Text('Rs 2800 / 40kg'),
                  ),
                  ListTile(
                    title: Text('Cotton'),
                    subtitle: Text('Demo only - not a live rate'),
                    trailing: Text('Rs 7500 / 40kg'),
                  ),
                ],
              ),
              _card(
                title: t('words'),
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search a word',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => search = v),
                  ),
                  const SizedBox(height: 12),
                  for (final w in words) Text('${w.$1} - ${w.$2}'),
                  if (words.isEmpty) const Text('No word found.'),
                ],
              ),
              _card(
                title: t('agent'),
                children: [
                  Text(t('agentNote')),
                  const SizedBox(height: 12),
                  TextField(
                    controller: agentController,
                    decoration: const InputDecoration(
                      labelText: 'Farmer name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => agentName = v,
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: agentCrop,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Wheat', child: Text('Wheat')),
                      DropdownMenuItem(value: 'Cotton', child: Text('Cotton')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => agentCrop = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (agentName.trim().isEmpty) return;
                        setState(() {
                          agentFarmers.add('$agentName - $agentCrop');
                          agentName = '';
                          agentController.clear();
                        });
                      },
                      child: const Text('Add farmer'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Farmers added: ${agentFarmers.length}'),
                  for (final f in agentFarmers) Text('• $f'),
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

class _Stage {
  final String name;
  final DateTime start;
  final DateTime end;
  const _Stage(this.name, this.start, this.end);
}

const List<(String, String)> _words = [
  ('Wheat', 'Gandum'),
  ('Cotton', 'Kapas'),
  ('Water', 'Pani'),
  ('Seed', 'Beej'),
  ('Soil', 'Mitti'),
  ('Field', 'Khait'),
  ('Harvest', 'Fasal Katna'),
  ('Fertilizer', 'Khad'),
  ('Pest', 'Keera'),
  ('Leaf', 'Patta'),
  ('Rain', 'Barish'),
  ('Sun', 'Dhoop'),
  ('Irrigation', 'Abpashi'),
  ('Crop', 'Fasal'),
  ('Farmer', 'Kisan'),
  ('Market', 'Mandi'),
  ('Price', 'Qeemat'),
  ('Sowing', 'Bijai'),
  ('Plough', 'Hal Chalana'),
  ('Weed', 'Jari Booti'),
  ('Yield', 'Paidawar'),
];

const Map<String, Map<String, String>> _texts = {
  'en': {
    'title': 'TerraSpeak',
    'tagline': "Farming in every farmer's own language.",
    'profile': 'Farmer Profile',
    'calendar': 'Crop Calendar',
    'calendarNote': 'Dates are estimated from sowing date, check your field.',
    'advice': 'Weekly Advice',
    'problem': 'Ask a Problem',
    'mandi': 'Mandi Rates',
    'words': 'Farming Words',
    'agent': 'Village Agent',
    'save': 'Save Profile',
    'saved': 'Profile saved.',
    'guidance': 'Get Guidance',
    'safety': 'Safety: this is general guidance only. Read the bottle label and confirm with your local agriculture officer before any spray or dose.',
    'agentNote': 'A village agent can help 15 to 20 farmers enter their details.',
    'footer': 'TerraSpeak v1.2 - Mandi demo only, advice is general guidance.',
  },
  'ur': {
    'title': 'TerraSpeak',
    'tagline': 'Har kisan ki apni zaban me kheti.',
    'profile': 'Kisan Profile',
    'calendar': 'Fasal Calendar',
    'calendarNote': 'Tareekhen bijai se andazan hain, apna khait check karo.',
    'advice': 'Haftawar Mashwara',
    'problem': 'Masla Poochna',
    'mandi': 'Mandi Rate',
    'words': 'Kheti ke Lafz',
    'agent': 'Gaon Agent',
    'save': 'Profile Save Karo',
    'saved': 'Profile save ho gaya.',
    'guidance': 'Mashwara Lo',
    'safety': 'Hifazat: ye sirf aam mashwara hai. Koi spray ya miqdar se pehle bottle ka label parho aur maqami agriculture officer se confirm karo.',
    'agentNote': 'Gaon agent 15 se 20 kisano ki madad kar sakta hai.',
    'footer': 'TerraSpeak v1.2 - Mandi sirf demo hai, mashwara aam rehnumai hai.',
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
