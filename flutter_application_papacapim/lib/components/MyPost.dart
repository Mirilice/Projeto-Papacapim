import 'package:flutter/material.dart';

class MyPost extends StatelessWidget {
  final String username;
  final String handle;
  final String content;
  final String profileImg;
  final int time;
  final int comments;
  final int reposts;
  final int favorites;

  const MyPost({
    super.key,
    required this.username,
    required this.handle,
    required this.content,
    required this.profileImg,
    required this.time,
    required this.comments,
    required this.reposts,
    required this.favorites
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(profileImg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12), 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "@$handle • $time""h", // Exemplo de tempo
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 15, height: 1.3),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionIcon(Icons.chat_bubble_outline, "$comments"),
                    _buildActionIcon(Icons.repeat, "$reposts"),
                    _buildActionIcon(Icons.favorite_border, "$favorites"),
                    _buildActionIcon(Icons.share_outlined, ""),
                  ],
                ),
                const Divider(
                  color: Colors.grey, 
                  thickness: 0.3,          
                ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}