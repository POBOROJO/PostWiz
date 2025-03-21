import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YoutubeThumbnailScreen extends StatefulWidget {
  @override
  _YoutubeThumbnailScreenState createState() => _YoutubeThumbnailScreenState();
}

class _YoutubeThumbnailScreenState extends State<YoutubeThumbnailScreen> {
  TextEditingController titleController = TextEditingController();
  String selectedStyle = 'Vibrant';
  String selectedCategory = 'Tech Review';
  Color primaryColor = Color(0xFFFF0000);
  bool isGenerating = false;
  bool thumbnailGenerated = false;
  
  final List<String> thumbnailStyles = [
    'Vibrant',
    'Minimalist',
    'Clickbait',
    'Professional',
    'Gaming',
  ];
  
  final List<String> videoCategories = [
    'Tech Review',
    'Tutorial',
    'Vlog',
    'Gaming',
    'Educational',
    'Entertainment',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Thumbnail Generator'),
        backgroundColor: Color(0xFFFF0000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generate YouTube Thumbnail',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            
            Text(
              'Video Title',
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
                controller: titleController,
                maxLines: 2,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your video title...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            Text(
              'Thumbnail Style',
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
                value: selectedStyle,
                items: thumbnailStyles.map((String style) {
                  return DropdownMenuItem<String>(
                    value: style,
                    child: Text(style),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedStyle = newValue;
                    });
                  }
                },
              ),
            ),
            
            SizedBox(height: 16),
            Text(
              'Video Category',
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
                value: selectedCategory,
                items: videoCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
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
                      isGenerating = false;
                      thumbnailGenerated = true;
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF0000),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Generate Thumbnail',
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
                ? Center(child: CircularProgressIndicator(color: Color(0xFFFF0000)))
                : !thumbnailGenerated
                  ? Center(
                      child: Text(
                        'Your thumbnail preview will appear here',
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Stack(
                              children: [
                                // Placeholder for thumbnail image
                                Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                
                                // Demo text overlay
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  right: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      titleController.text.isEmpty ? 
                                        'How to Master ${selectedCategory} in 2025' : 
                                        titleController.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                
                                // Style-specific overlay elements
                                if (selectedStyle == 'Clickbait')
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'SHOCKING!',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.refresh),
                              label: Text('Regenerate'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade800,
                              ),
                              onPressed: () {
                                setState(() {
                                  isGenerating = true;
                                });
                                
                                Future.delayed(Duration(seconds: 1), () {
                                  setState(() {
                                    isGenerating = false;
                                  });
                                });
                              },
                            ),
                            SizedBox(width: 16),
                            ElevatedButton.icon(
                              icon: Icon(Icons.download),
                              label: Text('Download'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF0000),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Thumbnail downloaded')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}