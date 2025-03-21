import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart'; // For sharing functionality

class TwitterThreadScreen extends StatefulWidget {
  @override
  _TwitterThreadScreenState createState() => _TwitterThreadScreenState();
}

class _TwitterThreadScreenState extends State<TwitterThreadScreen> {
  final List<String> niches = [
    'Tech',
    'Finance',
    'Marketing',
    'Health',
    'Education',
    'Crypto',
    'Startups',
    'Personal Development',
    'Tech Startups'
  ];
  
  final List<String> tones = [
    'Educational',
    'Controversial',
    'Storytelling',
    'Data-driven',
    'Humorous',
    'Excited',
    'Professional'
  ];
  
  String selectedNiche = 'Tech Startups';
  String selectedTone = 'Excited';
  TextEditingController topicController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isGenerating = false;
  
  // Generated tweet data
  Map<String, dynamic>? generatedTweet;
  
  @override
  void dispose() {
    topicController.dispose();
    contentController.dispose();
    super.dispose();
  }
  
  Future<void> generateTweet() async {
    if (contentController.text.isEmpty) {
      showSnackBar('Please enter tweet content');
      return;
    }

    setState(() {
      isGenerating = true;
    });
    
    try {
      final response = await http.post(
        Uri.parse('https://webartstudios.in/api-service/ai-startup-builder/tweetgen.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tweet_topic': topicController.text.isEmpty ? 'New Product Launch' : topicController.text,
          'tweet_content': contentController.text,
          'tweet_tone': selectedTone.toLowerCase(),
          'tweet_niche': selectedNiche.toLowerCase().replaceAll(' ', '_')
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          generatedTweet = data;
          isGenerating = false;
        });
      } else {
        setState(() {
          isGenerating = false;
        });
        showSnackBar('Error: Failed to generate tweet (${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        isGenerating = false;
      });
      showSnackBar('Error: $e');
    }
  }
  
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }
  
  void copyToClipboard() {
    if (generatedTweet != null) {
      Clipboard.setData(ClipboardData(text: generatedTweet!['tweet_text']));
      showSnackBar('Copied to clipboard');
    }
  }
  
  void shareTweet() {
    if (generatedTweet != null) {
      Share.share(generatedTweet!['tweet_text']);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweet Generator'),
        backgroundColor: Color(0xFF1DA1F2),
      ),
      body: Container(
        color: Color(0xFF15202B), // Twitter dark theme
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generate Tweet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              
              Text(
                'Tweet Topic',
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
                  controller: topicController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'New Product Launch',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              Text(
                'Tweet Content',
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
                  controller: contentController,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Describe what you want to tweet about',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isGenerating ? null : generateTweet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1DA1F2),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isGenerating
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Generate Tweet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              
              SizedBox(height: 24),
              Expanded(
                child: generatedTweet == null && !isGenerating
                  ? Center(
                      child: Text(
                        'Your generated tweet will appear here',
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    )
                  : isGenerating
                    ? Center(child: CircularProgressIndicator(color: Color(0xFF1DA1F2)))
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.2))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Generated Tweet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: generatedTweet!['character_count'] <= 280 
                                      ? Colors.green.withOpacity(0.7) 
                                      : Colors.red.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${generatedTweet!['character_count']} / 280',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFF192734),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        generatedTweet!['tweet_text'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hashtags:',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.7),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              generatedTweet!['hashtags_used'],
                                              style: TextStyle(
                                                color: Color(0xFF1DA1F2),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton.icon(
                                  icon: Icon(Icons.refresh, color: Colors.white),
                                  label: Text(
                                    'Regenerate',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: isGenerating ? null : generateTweet,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.white.withOpacity(0.5)),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.copy, color: Colors.white),
                                      tooltip: 'Copy to clipboard',
                                      onPressed: copyToClipboard,
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(0.1),
                                        padding: EdgeInsets.all(8),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.share, color: Colors.white),
                                      tooltip: 'Share tweet',
                                      onPressed: shareTweet,
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(0.1),
                                        padding: EdgeInsets.all(8),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.send, size: 18),
                                      label: Text('Tweet'),
                                      onPressed: () {
                                        // Here you would implement direct posting to Twitter
                                        // This typically requires Twitter API integration
                                        showSnackBar('Tweet functionality would be implemented here');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF1DA1F2),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}