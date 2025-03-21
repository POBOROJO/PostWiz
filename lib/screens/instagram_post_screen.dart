import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality

class InstagramPostScreen extends StatefulWidget {
  @override
  _InstagramPostScreenState createState() => _InstagramPostScreenState();
}

class _InstagramPostScreenState extends State<InstagramPostScreen> {
  final List<String> niches = [
    'Fashion',
    'Fitness',
    'Food',
    'Travel',
    'Beauty',
    'Lifestyle',
    'Photography',
    'Art'
  ];
  
  final List<String> tones = [
    'Trendy',
    'Inspirational',
    'Casual',
    'Humorous',
    'Elegant'
  ];
  
  String selectedNiche = 'Lifestyle';
  String selectedTone = 'Trendy';
  TextEditingController ideaController = TextEditingController();
  String generatedCaption = '';
  List<String> generatedHashtags = [];
  bool isGenerating = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram Post Generator'),
        backgroundColor: Color(0xFFE1306C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generate Instagram Post',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            
            Text(
              'Select your niche',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Color(0xFF2D2D2D),
                underline: SizedBox(),
                style: TextStyle(color: Colors.white),
                value: selectedNiche,
                items: niches.map((String niche) {
                  return DropdownMenuItem<String>(
                    value: niche,
                    child: Text(niche),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedNiche = newValue;
                    });
                  }
                },
              ),
            ),
            
            SizedBox(height: 16),
            Text(
              'Select tone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Color(0xFF2D2D2D),
                underline: SizedBox(),
                style: TextStyle(color: Colors.white),
                value: selectedTone,
                items: tones.map((String tone) {
                  return DropdownMenuItem<String>(
                    value: tone,
                    child: Text(tone),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedTone = newValue;
                    });
                  }
                },
              ),
            ),
            
            SizedBox(height: 16),
            Text(
              'Idea Description (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: ideaController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Describe your image or idea...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGenerating = true;
                  });
                  
                  // Simulate generating content
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      _generateSamplePost();
                      isGenerating = false;
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE1306C),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Generate Post',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            Expanded(
              child: isGenerating
                ? Center(child: CircularProgressIndicator(color: Color(0xFFE1306C)))
                : generatedCaption.isEmpty
                  ? Center(
                      child: Text(
                        'Your Instagram caption and hashtags will appear here',
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Caption',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            flex: 3,
                            child: SingleChildScrollView(
                              child: Text(
                                generatedCaption,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Hashtags',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: generatedHashtags.map((hashtag) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE1306C).withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      hashtag,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.copy, color: Colors.white),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                    text: generatedCaption + '\n\n' + generatedHashtags.join(' ')
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Copied to clipboard')),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.save_alt, color: Colors.white),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Post saved')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _generateSamplePost() {
    // This would be replaced with actual AI generation
    generatedCaption = "✨ Finding magic in everyday moments. Life isn't about waiting for the storm to pass, it's about learning to dance in the rain.\n\nEmbracing the ${selectedNiche.toLowerCase()} journey one day at a time, and loving every step along the way.";
    
    generatedHashtags = [
      "#${selectedNiche.toLowerCase()}",
      "#instavibes",
      "#goodvibesonly",
      "#authentic${selectedNiche}",
      "#${selectedTone.toLowerCase()}vibes",
      "#dailyinspo",
      "#liveyourbestlife",
      "#instadaily",
      "#${selectedNiche.toLowerCase()}love",
      "#create"
    ];
  }
}