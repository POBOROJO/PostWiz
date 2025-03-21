import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ContentPlannerScreen extends StatefulWidget {
  @override
  _ContentPlannerScreenState createState() => _ContentPlannerScreenState();
}

class _ContentPlannerScreenState extends State<ContentPlannerScreen> {
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _brandDescriptionController = TextEditingController();
  
  // Content type selection states
  Map<String, bool> contentTypes = {
    'Posts': false,
    'Short Videos': false,
    'Stories': false,
    'Reels': false,
    'Carousels': false,
    'Live Streams': false,
    'Tweets': false,
    'Blog Posts': false,
  };
  
  // Form errors state
  Map<String, String?> formErrors = {
    'brandName': null,
    'brandDescription': null,
    'contentTypes': null,
  };
  
  // Generated plan data
  Map<String, dynamic>? planData;
  bool isLoading = false;
  String? error;
  
  @override
  void dispose() {
    _brandNameController.dispose();
    _brandDescriptionController.dispose();
    super.dispose();
  }
  
  // Validate the form
  bool _validateForm() {
    bool isValid = true;
    
    setState(() {
      // Validate brand name
      if (_brandNameController.text.trim().isEmpty) {
        formErrors['brandName'] = 'Brand name is required';
        isValid = false;
      } else {
        formErrors['brandName'] = null;
      }
      
      // Validate brand description
      if (_brandDescriptionController.text.trim().isEmpty) {
        formErrors['brandDescription'] = 'Brand description is required';
        isValid = false;
      } else {
        formErrors['brandDescription'] = null;
      }
      
      // Validate content types
      List<String> selectedTypes = contentTypes.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      
      if (selectedTypes.isEmpty) {
        formErrors['contentTypes'] = 'Select at least one content type';
        isValid = false;
      } else {
        formErrors['contentTypes'] = null;
      }
    });
    
    return isValid;
  }
  
  void _clearForm() {
    setState(() {
      _brandNameController.clear();
      _brandDescriptionController.clear();
      contentTypes.forEach((key, value) {
        contentTypes[key] = false;
      });
      planData = null;
      error = null;
      formErrors = {
        'brandName': null,
        'brandDescription': null,
        'contentTypes': null,
      };
    });
  }
  
  Future<void> _generateStrategy() async {
    // Validate form first
    if (!_validateForm()) {
      return;
    }
    
    setState(() {
      isLoading = true;
      error = null;
    });
    
    // Prepare data for API
    List<String> selectedTypes = contentTypes.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toLowerCase().replaceAll(' ', '_'))
        .toList();
    
    try {
      final response = await http.post(
        Uri.parse('https://api-service.webartstudios.in/ai-startup-builder/contentplanner.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'brand_name': _brandNameController.text,
          'brand_description': _brandDescriptionController.text,
          'content_types': selectedTypes,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          planData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to generate strategy. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }
  
  // Download the generated plan
  void _downloadPlan() {
    if (planData == null) return;
    
    final content = jsonEncode(planData);
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Content plan copied to clipboard')),
    );
    
    // Note: In a real mobile app, you would implement file saving functionality here
    // using packages like path_provider and file_saver
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 71, 71),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFFBB86FC)),
            SizedBox(width: 10),
            Text(
              'Social Media Strategy Planner',
              style: TextStyle(
                color: Color(0xFFBB86FC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left panel - Input form
            Expanded(
              child: Card(
                color: Color(0xFF121212),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Color(0xFFBB86FC).withOpacity(0.5), width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand Name
                      Text(
                        'Brand Name',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _brandNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g., Eco Lifestyle Co.',
                          hintStyle: TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.black45,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: formErrors['brandName'] != null
                                ? Colors.red.withOpacity(0.8) 
                                : Color(0xFFBB86FC).withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFBB86FC)),
                          ),
                          errorText: formErrors['brandName'],
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        onChanged: (value) {
                          if (formErrors['brandName'] != null) {
                            setState(() {
                              formErrors['brandName'] = null;
                            });
                          }
                        },
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Brand Description
                      Text(
                        'Brand Description',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _brandDescriptionController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Describe your brand, mission, target audience, and values...',
                          hintStyle: TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.black45,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: formErrors['brandDescription'] != null
                                ? Colors.red.withOpacity(0.8)
                                : Color(0xFFBB86FC).withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFBB86FC)),
                          ),
                          errorText: formErrors['brandDescription'],
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        onChanged: (value) {
                          if (formErrors['brandDescription'] != null) {
                            setState(() {
                              formErrors['brandDescription'] = null;
                            });
                          }
                        },
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Content Types
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Content Types',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (formErrors['contentTypes'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                formErrors['contentTypes']!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: contentTypes.entries.map((entry) {
                              return FilterChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        color: entry.value ? Colors.white : Colors.white70,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      entry.value ? Icons.check : Icons.add_circle_outline,
                                      size: 16,
                                      color: entry.value ? Color(0xFFBB86FC) : Colors.white30,
                                    ),
                                  ],
                                ),
                                selected: entry.value,
                                onSelected: (bool selected) {
                                  setState(() {
                                    contentTypes[entry.key] = selected;
                                    
                                    // Clear error if at least one is selected
                                    if (selected && formErrors['contentTypes'] != null) {
                                      formErrors['contentTypes'] = null;
                                    }
                                  });
                                },
                                backgroundColor: Colors.black45,
                                selectedColor: Color(0xFF3A3053),
                                checkmarkColor: Color(0xFFBB86FC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(
                                    color: entry.value 
                                        ? Color(0xFFBB86FC) 
                                        : formErrors['contentTypes'] != null
                                          ? Colors.red.withOpacity(0.8)
                                          : Color(0xFFBB86FC).withOpacity(0.3),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      
                      Spacer(),
                      
                      // Button Row
                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: Icon(Icons.clear),
                            label: Text('Clear'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: BorderSide(color: Colors.white30),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            onPressed: _clearForm,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: isLoading 
                                ? SizedBox(
                                    width: 20, 
                                    height: 20, 
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    )
                                  )
                                : Icon(Icons.send),
                              label: Text(isLoading ? 'Generating...' : 'Generate Strategy'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFBB86FC),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: isLoading ? null : _generateStrategy,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 16),
            
            // Right panel - Strategy display
            Expanded(
              child: Card(
                color: Color(0xFF121212),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Color(0xFFBB86FC).withOpacity(0.5), width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFFBB86FC),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Our AI is crafting the perfect social media strategy for your brand...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 64,
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Error',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Text(
                                error!,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24),
                              ElevatedButton.icon(
                                icon: Icon(Icons.refresh),
                                label: Text('Try Again'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFBB86FC),
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: _generateStrategy,
                              ),
                            ],
                          ),
                        )
                      : planData == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFBB86FC),
                                  size: 64,
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'Your social media strategy will appear here',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Fill out the form and click "Generate Strategy" to create your customized social media plan.',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Social Media Strategy Plan',
                                            style: TextStyle(
                                              color: Color(0xFFBB86FC),
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 6),
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFBB86FC).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: Color(0xFFBB86FC).withOpacity(0.5)),
                                            ),
                                            child: Text(
                                              _brandNameController.text,
                                              style: TextStyle(
                                                color: Color(0xFFBB86FC),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(color: Color(0xFFBB86FC).withOpacity(0.3), height: 32),
                                
                                // Weekly Schedule
                                if (planData!.containsKey('weekly_schedule')) ...[
                                  Text(
                                    'Weekly Content Schedule',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1.5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: planData!['weekly_schedule'].length,
                                    itemBuilder: (context, index) {
                                      final day = planData!['weekly_schedule'].keys.elementAt(index);
                                      final content = planData!['weekly_schedule'][day];
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color(0xFFBB86FC).withOpacity(0.3)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              day,
                                              style: TextStyle(
                                                color: Color(0xFFBB86FC),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Expanded(
                                              child: Text(
                                                content,
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 24),
                                ],
                                
                                // Content Ideas
                                if (planData!.containsKey('content_ideas')) ...[
                                  Text(
                                    'Content Ideas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: planData!['content_ideas'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '•',
                                              style: TextStyle(
                                                color: Color(0xFFBB86FC),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                planData!['content_ideas'][index],
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 24),
                                ],
                                
                                // Hashtag Strategy
                                if (planData!.containsKey('hashtag_strategy')) ...[
                                  Text(
                                    'Hashtag Strategy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: List<Widget>.from(
                                      planData!['hashtag_strategy'].map((hashtag) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFBB86FC).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            '#$hashtag',
                                            style: TextStyle(
                                              color: Color(0xFFBB86FC),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                ],
                                
                                // Best Times to Post
                                if (planData!.containsKey('best_posting_times')) ...[
                                  Text(
                                    'Best Times to Post',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Column(
                                    children: planData!['best_posting_times'].entries.map<Widget>((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: Color(0xFFBB86FC).withOpacity(0.5)),
                                              ),
                                              child: Text(
                                                entry.key,
                                                style: TextStyle(
                                                  color: Color(0xFFBB86FC),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                entry.value is List
                                                  ? (entry.value as List).join(', ')
                                                  : entry.value.toString(),
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 24),
                                ],
                                
                                // Additional Tips
                                if (planData!.containsKey('additional_tips')) ...[
                                  Text(
                                    'Additional Tips',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: planData!['additional_tips'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '•',
                                              style: TextStyle(
                                                color: Color(0xFFBB86FC),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                planData!['additional_tips'][index],
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 24),
                                ],
                                
                                // Action buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.download),
                                      label: Text('Download Plan'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFBB86FC),
                                        foregroundColor: Colors.black,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      onPressed: _downloadPlan,
                                    ),
                                    SizedBox(width: 12),
                                    OutlinedButton.icon(
                                      icon: Icon(Icons.refresh),
                                      label: Text('Regenerate'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Color(0xFFBB86FC),
                                        side: BorderSide(color: Color(0xFFBB86FC)),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      onPressed: _generateStrategy,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}