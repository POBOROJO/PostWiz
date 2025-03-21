import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LinkedInPostScreen extends StatefulWidget {
  @override
  _LinkedInPostScreenState createState() => _LinkedInPostScreenState();
}

class _LinkedInPostScreenState extends State<LinkedInPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _includeImage = false;
  String _selectedTone = 'Professional';
  String _selectedNiche = 'Technology';
  bool _isLoading = false;
  
  // Response data controllers
  Map<String, dynamic>? _generatedPost;
  
  final List<String> _toneOptions = [
    'Professional', 
    'Casual', 
    'Inspirational', 
    'Educational',
    'Promotional'
  ];
  
  final List<String> _nicheOptions = [
    'Technology',
    'Finance',
    'Marketing',
    'Human Resources',
    'Education',
    'Healthcare',
    'E-commerce',
    'Real Estate'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  // Function to make API call
  Future<void> _generatePost() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.post(
        Uri.parse('https://webartstudios.in/api-service/ai-startup-builder/linkedinpost.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'post_title': _titleController.text,
          'post_content': _contentController.text,
          'post_tone': _selectedTone.toLowerCase(),
          'post_niche': _selectedNiche.toLowerCase().replaceAll(' ', ''),
        }),
      );
      
      if (response.statusCode == 200) {
        setState(() {
          _generatedPost = jsonDecode(response.body);
          _isLoading = false;
        });
        
        // Show the generated post in a dialog
        _showGeneratedPostDialog();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Failed to generate post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error: $e');
    }
  }
  
  void _showGeneratedPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF252525),
        title: Text(
          'Generated LinkedIn Post',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hook:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _generatedPost?['hook'] ?? '',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Main Content:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _generatedPost?['main_content'] ?? '',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Hashtags:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _generatedPost?['hashtags'] ?? '',
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                'Call to Action:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _generatedPost?['call_to_action'] ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: TextStyle(color: Color(0xFF1E47FF))),
          ),
          TextButton(
            onPressed: () {
              // Add copy to clipboard functionality
              Navigator.of(context).pop();
            },
            child: Text('Copy', style: TextStyle(color: Color(0xFF1E47FF))),
          ),
        ],
      ),
    );
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF252525),
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: Color(0xFF1E47FF))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LinkedIn Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1E47FF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Color(0xFF121212),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create LinkedIn Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Post Title/Headline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter an attention-grabbing headline',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    fillColor: Colors.white.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Post Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Write your post content here...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    fillColor: Colors.white.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 10,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Include Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: _includeImage,
                      onChanged: (value) {
                        setState(() {
                          _includeImage = value;
                        });
                      },
                      activeColor: Color(0xFF1E47FF),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (_includeImage) ...[
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white.withOpacity(0.7),
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Post Tone',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedTone,
                                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                dropdownColor: Color(0xFF252525),
                                style: TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedTone = newValue!;
                                  });
                                },
                                items: _toneOptions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
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
                            'Content Niche',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedNiche,
                                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                dropdownColor: Color(0xFF252525),
                                style: TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedNiche = newValue!;
                                  });
                                },
                                items: _nicheOptions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: _isLoading 
                          ? SizedBox(
                              width: 20, 
                              height: 20, 
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            )
                          : Icon(Icons.auto_awesome, color: Colors.white),
                        label: Text(
                          _isLoading ? 'Generating...' : 'Generate Post',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _isLoading ? null : _generatePost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E47FF),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.save_alt, color: Colors.white),
                        label: Text(
                          'Save Draft',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // Save draft logic
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.5)),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.share, color: Colors.white),
                        label: Text(
                          'Preview',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _generatedPost != null ? () {
                          _showGeneratedPostDialog();
                        } : null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.5)),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}