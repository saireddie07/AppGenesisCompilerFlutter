import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'challenge_screen.dart';
import '../API.dart'; // Import the API service

class Question {
  final int id;
  final String title;
  final String shortDescription;
  final String level;
  final String topic;

  Question({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.level,
    required this.topic,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      title: json['title'],
      shortDescription: json['short_description'],
      level: json['leve'], // Note: 'leve' is used in the API response
      topic: json['topic'],
    );
  }
}

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Question> allQuestions = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final questionsData = await _apiService.getAllQuestions();
      setState(() {
        allQuestions = questionsData.map((q) => Question.fromJson(q)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching questions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
        ),
      ),
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                _buildPracticeSection('All Challenges', allQuestions),
                _buildPracticeSection('Easy Challenges', allQuestions.where((q) => q.level == 'E').toList()),
                _buildPracticeSection('Medium Challenges', allQuestions.where((q) => q.level == 'M').toList()),
                _buildPracticeSection('Hard Challenges', allQuestions.where((q) => q.level == 'H').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: _getTabColor().withOpacity(0.2),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        tabs: [
          Tab(text: 'All'),
          Tab(text: 'Easy'),
          Tab(text: 'Medium'),
          Tab(text: 'Hard'),
        ],
      ),
    );
  }

  Color _getTabColor() {
    switch (_tabController.index) {
      case 1: // Easy
        return Colors.green;
      case 2: // Medium
        return Colors.orange;
      case 3: // Hard
        return Colors.red;
      default: // All
        return Colors.white;
    }
  }

  Widget _buildPracticeSection(String title, List<Question> questions) {
    return AnimationLimiter(
      child: ListView.builder(
        key: _listKey,
        padding: EdgeInsets.all(20),
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionTitle(title);
          }
          return AnimationConfiguration.staggeredList(
            position: index - 1,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildQuestionCard(questions[index - 1]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black.withOpacity(0.3),
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          // TODO: Implement question details view
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                  _buildDifficultyChip(question.level),
                ],
              ),
              SizedBox(height: 8),
              Text(
                question.topic,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 12),
              Text(
                question.shortDescription,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              _buildSolveButton(question),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String level) {
    String difficulty;
    switch (level) {
      case 'E':
        difficulty = 'Easy';
        break;
      case 'M':
        difficulty = 'Medium';
        break;
      case 'H':
        difficulty = 'Hard';
        break;
      default:
        difficulty = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getDifficultyColor(difficulty),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        difficulty,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSolveButton(Question question) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeScreen(
                title: question.title,
                description: question.shortDescription,
                difficulty: question.level,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[700],
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow),
            SizedBox(width: 8),
            Text('Solve'),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}