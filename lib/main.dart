import 'package:flutter/material.dart';
import 'package:postwiz/screens/linkedin_post_screen.dart';
import 'package:postwiz/screens/instagram_post_screen.dart';
import 'package:postwiz/screens/twitter_thread_screen.dart';
import 'package:postwiz/screens/youtube_thumbnail_screen.dart';
import 'package:postwiz/screens/video_editor_screen.dart';
import 'package:postwiz/screens/content_planner_screen.dart';

void main() {
  runApp(PostwizApp());
}

class PostwizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postwiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1E47FF),
        scaffoldBackgroundColor: Color(0xFF0D1117),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF1E47FF),
          secondary: Color(0xFF3A85FF),
          surface: Color(0xFF1A1F29),
          background: Color(0xFF0D1117),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize:
            20,
          ),
          bodyLarge: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E47FF),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.5)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    FeatureListScreen(),
    ContentPlannerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          color: Color(0xFF0D1117),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Features',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Planner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          SizedBox(height: 24),
          Text(
            'Welcome back, Alex!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            'Let\'s create amazing content today',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 24),
          _buildQuickActions(context),
          SizedBox(height: 24),
          Text(
            'Recent Content',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Expanded(
            child: _buildRecentContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Postwiz',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildFeatureCard(
              context,
              'LinkedIn Post',
              Icons.business,
              Color(0xFF1E47FF),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LinkedInPostScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              'Instagram',
              Icons.camera_alt,
              Color(0xFFE1306C),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InstagramPostScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              'Twitter Threads',
              Icons.chat_bubble_outline,
              Color(0xFF1DA1F2),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TwitterThreadScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              'YT Thumbnail',
              Icons.play_circle_outline,
              Color(0xFFFF0000),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YoutubeThumbnailScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              'Video Editor',
              Icons.chat_bubble_outline,
              Color(0xFF1DA1F2),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoEditorScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              'Content Planner',
              Icons.chat_bubble_outline,
              Color(0xFF1DA1F2),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContentPlannerScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentContent(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    index % 2 == 0 ? Icons.business : Icons.camera_alt,
                    color: index % 2 == 0 ? Color(0xFF1E47FF) : Color(0xFFE1306C),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index % 2 == 0 ? 'LinkedIn Post Draft' : 'Instagram Post Idea',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Last edited 2 hours ago',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FeatureListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'title': 'LinkedIn Post',
      'icon': Icons.business,
      'color': Color(0xFF1E47FF),
      'screen': LinkedInPostScreen(),
    },
    {
      'title': 'Instagram',
      'icon': Icons.camera_alt,
      'color': Color(0xFFE1306C),
      'screen': InstagramPostScreen(),
    },
    {
      'title': 'Twitter Threads',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFF1DA1F2),
      'screen': TwitterThreadScreen(),
    },
    {
      'title': 'Content Planner',
      'icon': Icons.calendar_today,
      'color': Color(0xFF00C853),
      'screen': ContentPlannerScreen(),
    },
    {
      'title': 'YT Thumbnail',
      'icon': Icons.play_circle_outline,
      'color': Color(0xFFFF0000),
      'screen': YoutubeThumbnailScreen(),
    },
    {
      'title': 'Video Editor',
      'icon': Icons.videocam,
      'color': Color(0xFFFFA000),
      'screen': VideoEditorScreen(),
    },
    {
      'title': 'Audio Editor',
      'icon': Icons.audiotrack,
      'color': Color(0xFF7C4DFF),
      'screen': ContentPlannerScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            'Create content for any platform',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                return _buildFeatureCard(
                  context,
                  features[index]['title'],
                  features[index]['icon'],
                  features[index]['color'],
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => features[index]['screen']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 36,
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create now',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentPlannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content Planner',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            'Schedule and organize your content',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 24),
          _buildCalendarHeader(context),
          SizedBox(height: 16),
          _buildWeekCalendar(context),
          SizedBox(height: 24),
          Expanded(
            child: _buildScheduledContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'March 2025',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekCalendar(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          bool isSelected = index == 2;
          return Container(
            width: 60,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${17 + index}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                if (index == 0 || index == 3)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == 0 ? Color(0xFFE1306C) : Color(0xFF1DA1F2),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduledContent(BuildContext context) {
    final platforms = ['LinkedIn', 'Instagram', 'Twitter', 'YouTube'];
    final icons = [Icons.business, Icons.camera_alt, Icons.chat_bubble_outline, Icons.play_circle_outline];
    final colors = [Color(0xFF1E47FF), Color(0xFFE1306C), Color(0xFF1DA1F2), Color(0xFFFF0000)];
    final times = ['9:00 AM', '12:30 PM', '3:45 PM', '5:00 PM'];

    return ListView.separated(
      itemCount: platforms.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colors[index].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icons[index],
                    color: colors[index],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${platforms[index]} Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Scheduled for ${times[index]}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white.withOpacity(0.5)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Alex Johnson',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 4),
          Text(
            'Marketing Specialist',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 24),
          _buildStatsRow(context),
          SizedBox(height: 32),
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard(context, '32', 'Posts Created'),
        _buildStatCard(context, '8', 'Scheduled'),
        _buildStatCard(context, '4', 'Platforms'),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final settings = [
      {'icon': Icons.person, 'title': 'Account Settings'},
      {'icon': Icons.credit_card, 'title': 'Subscription Plan'},
      {'icon': Icons.link, 'title': 'Connected Accounts'},
      {'icon': Icons.logout, 'title': 'Log Out'},
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: settings.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withOpacity(0.1),
          height: 1,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              settings[index]['icon'] as IconData,
              color: index == settings.length - 1
                  ? Colors.red
                  : Colors.white.withOpacity(0.7),
            ),
            title: Text(
              settings[index]['title'] as String,
              style: TextStyle(
                color: index == settings.length - 1
                    ? Colors.red
                    : Colors.white,
              ),
            ),
            trailing: index == settings.length - 1
                ? null
                : Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
            onTap: () {},
          );
        },
      ),
    );
  }
}