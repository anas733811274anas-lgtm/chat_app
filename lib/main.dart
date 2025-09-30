import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'صفحة الملف الشخصي',
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  File? coverImage;
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        if (type == "cover") {
          coverImage = File(picked.path);
        } else {
          profileImage = File(picked.path);
        }
      });
    }
  }

  Widget buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget buildPostItem(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhotoItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "${index + 1} صورة",
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Cover Image Area
              GestureDetector(
                onTap: () => _pickImage("cover"),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: coverImage == null
                        ? const LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue.shade400,
                              Colors.blue.shade200,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                    image: coverImage != null
                        ? DecorationImage(
                            image: FileImage(coverImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: coverImage == null
                      ? const Center(
                          child: Text(
                            "صورة خلفية (اضغط للتغيير)",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : null,
                ),
              ),

              // Profile Image and Details Area
              Positioned(
                bottom: -50,
                child: GestureDetector(
                  onTap: () => _pickImage("profile"),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : null,
                          backgroundColor: profileImage == null
                              ? Colors.grey[300]
                              : null,
                          child: profileImage == null
                              ? const Text("صورة")
                              : null,
                        ),
                      ),
                      const SizedBox(height: 60),
                      const Column(
                        children: [
                          Text(
                            "اسم المستخدم",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "هنا سيرة ذاتية قصيرة للتجربة فقط...",
                            style: TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatItem("متابعات", "120"),
                buildStatItem("منشورات", "25"),
                buildStatItem("صور", "5"),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "منشورات"),
              Tab(text: "الصور"),
              Tab(text: "الإعدادات"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Posts Tab
                ListView(
                  children: [
                    buildPostItem("تجربة منشور 1", "هذا هو محتوى المنشور الأول."),
                    buildPostItem("تجربة منشور 2", "هذا هو محتوى المنشور الثاني."),
                    buildPostItem("تجربة منشور 3", "هذا هو محتوى المنشور الثالث."),
                  ],
                ),

                // Photos Tab
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return buildPhotoItem(index);
                  },
                ),

                // Settings Tab
                const Center(
                  child: Text("قريباً: إعدادات التطبيق"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
