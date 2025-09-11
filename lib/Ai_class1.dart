import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // Your Gemini API Key
  final String _apiKey = 'AIzaSyBTP2M3wkoGkd6xJWNs81AdnZB57wQm9Ek';

  // University context
  final String _climateContext = '''
Context: Northern University of Business and Technology,Khulna

The program is designed to satisfy the growing demand for computer professionals, civil engineering, electrical and electronic  engineering and architecture throughout the country.

It gives students the opportunity to obtain broad-based knowledge and expertise of Computer Science and engineering, electrical engineering and civil engineering.

 also a freedom to tailor the program according to the student's individual needs.
 
Moreover, there are sufficient number of Physics, Mathematics, Electrical Engineering, Mechanical Engineering and other basic Science, Commerce and Arts courses in this course curriculum which enables under graduate of this department to revolve around different branches of knowledge.

sadik photo, this is sadik photo , who is sadik + photo , shahed photo , shahed image , who is shahed + photo 
  ''';

  // Image URLs
  final String _sadikImageUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=250&q=80';
  final String _shahedImageUrl = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=250&q=80';

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: "Hello! I'm your Northern University of Business and Technology,Khulna assistant. I can help you understand About Northern University of Business and Technology,Khulna, adaptation strategies, and academic activities. What would you like to know?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      // Always call Gemini for text analysis
      final response = await _callGemini(message.trim());

      if (response.startsWith('[SHOW_SADIK_PHOTO]')) {
        String text = response.substring('[SHOW_SADIK_PHOTO]'.length).trim();
        setState(() {
          _messages.add(ChatMessage(
            text: text.isNotEmpty ? text : "Here is Sadik's photo:",
            isUser: false,
            timestamp: DateTime.now(),
            imageUrl: _sadikImageUrl,
            isImage: true,
          ));
          _isLoading = false;
        });
      } else if (response.startsWith('[SHOW_SHAHED_PHOTO]')) {
        String text = response.substring('[SHOW_SHAHED_PHOTO]'.length).trim();
        setState(() {
          _messages.add(ChatMessage(
            text: text.isNotEmpty ? text : "Here is Shahed's photo:",
            isUser: false,
            timestamp: DateTime.now(),
            imageUrl: _shahedImageUrl,
            isImage: true,
          ));
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Sorry, I encountered an error: ${e.toString()}. Please check your internet connection and try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  Future<String> _callGemini(String userMessage) async {
    try {
      final String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey';

      final headers = {
        'Content-Type': 'application/json',
      };

      // Updated prompt for text analysis
      final prompt = """
$_climateContext

Analyze the user question carefully. If the user is requesting a photo, image, or chobi of Sadik (examples: "sadik photo", "show sadik image", "sadik er chobi dekhao", "who is sadik + photo", "sadik ke + photo"), start your response with exactly [SHOW_SADIK_PHOTO] followed by any additional text response, such as a description if it's a "who is" query (e.g., [SHOW_SADIK_PHOTO] Sadik is a notable figure associated with Northern University of Business and Technology, Khulna.).

Similarly, if requesting for Shahed (examples: "shahed photo", "shahed image", "shahed er chobi", "who is shahed + photo"), start with exactly [SHOW_SHAHED_PHOTO] followed by any additional text.

Do not use the markers unless the query is specifically asking for the photo/image. For all other queries, provide a helpful response based on the context without any markers.

User Question: $userMessage
""";

      final body = jsonEncode({
        'contents': [{
          'parts': [{
            'text': prompt
          }]
        }],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 500,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('candidates') &&
            data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0].containsKey('content') &&
            data['candidates'][0]['content'].containsKey('parts') &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {

          final text = data['candidates'][0]['content']['parts'][0]['text'];
          return text?.toString().trim() ?? 'Sorry, I could not generate a response.';
        } else {
          throw Exception('Invalid response format from Gemini API');
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        throw Exception('API Error (${response.statusCode}): $errorMessage');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      if (e.toString().contains('API Error')) {
        rethrow;
      }
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  void _scrollToBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Northern University of Business and Technology,Khulna (Bot)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return _buildLoadingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.school),
              radius: 16,
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue.shade500 : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: message.isImage
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.text.isNotEmpty) ...[
                    Text(
                      message.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 250,
                      maxHeight: 250,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        message.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 200,
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported, size: 50, color: Colors.grey.shade600),
                                SizedBox(height: 8),
                                Text(
                                  'Image not available',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                Text(
                                  'Check image URL',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
                  : Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue.shade500,
              child: Icon(Icons.person, color: Colors.white, size: 20),
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.arrow_downward, color: Colors.white, size: 20),
            radius: 16,
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "Thinking...",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Ask about Northern University of Business and Technology,Khulna",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _isLoading ? null : _sendMessage,
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: _isLoading ? Colors.grey : Colors.green.shade600,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isLoading ? Colors.grey : Colors.green).withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _isLoading ? null : () => _sendMessage(_controller.text),
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final bool isImage;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.isImage = false,
  });
}