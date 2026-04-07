import 'package:flutter/material.dart';

import '../models/drama.dart';
import '../widgets/drama_poster.dart';
import 'drama_detail_screen.dart';
import 'drama_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isAdmin,
    required this.initialData,
    required this.onLogout,
  });

  final bool isAdmin;
  final List<Drama> initialData;
  final VoidCallback onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  late List<Drama> _dramas;

  @override
  void initState() {
    super.initState();
    _dramas = [...widget.initialData];
  }

  Future<void> _openAddDrama() async {
    final result = await Navigator.push<DramaFormResult>(
      context,
      MaterialPageRoute(builder: (_) => const DramaFormScreen()),
    );
    if (result == null) return;

    setState(() {
      _dramas.insert(
        0,
        Drama(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: result.title,
          year: result.year,
          rating: result.rating,
          genre: result.genre,
          tags: result.tags,
          synopsis: result.synopsis,
          posterAsset: result.posterAsset,
          isFavorite: false,
          isInMyList: false,
        ),
      );
    });
  }

  Future<void> _openEditDrama(Drama drama) async {
    final result = await Navigator.push<DramaFormResult>(
      context,
      MaterialPageRoute(builder: (_) => DramaFormScreen(initialDrama: drama)),
    );
    if (result == null) return;

    setState(() {
      final index = _dramas.indexWhere((d) => d.id == drama.id);
      if (index == -1) return;
      _dramas[index] = _dramas[index].copyWith(
        title: result.title,
        year: result.year,
        rating: result.rating,
        genre: result.genre,
        tags: result.tags,
        synopsis: result.synopsis,
        posterAsset: result.posterAsset,
      );
    });
  }

  void _deleteDrama(Drama drama) {
    setState(() {
      _dramas.removeWhere((d) => d.id == drama.id);
    });
  }

  Future<void> _openDetail(Drama drama) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DramaDetailScreen(
          drama: drama,
          isAdmin: widget.isAdmin,
          onEdit: widget.isAdmin ? () => _openEditDrama(drama) : null,
          onDelete: widget.isAdmin ? () => _deleteDrama(drama) : null,
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1EC9D4), Color(0xFF032D43)],
          ),
        ),
        child: SafeArea(
          child: _buildCurrentTab(),
        ),
      ),
      floatingActionButton: widget.isAdmin && _tabIndex == 0
          ? FloatingActionButton(
              onPressed: _openAddDrama,
              backgroundColor: const Color(0xFF0B6588),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _tabIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'My List'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_tabIndex) {
      case 0:
        return _CatalogTab(
          isAdmin: widget.isAdmin,
          dramas: _dramas,
          onOpenDetail: _openDetail,
          onEdit: _openEditDrama,
        );
      case 1:
        return _SimpleListTab(
          title: 'My Favorit',
          dramas: _dramas.where((d) => d.isFavorite).toList(),
          onOpenDetail: _openDetail,
        );
      case 2:
        return _SimpleListTab(
          title: 'My List',
          dramas: _dramas.where((d) => d.isInMyList).toList(),
          onOpenDetail: _openDetail,
        );
      default:
        return _ProfileTab(
          isAdmin: widget.isAdmin,
          onLogout: widget.onLogout,
        );
    }
  }
}

class _CatalogTab extends StatelessWidget {
  const _CatalogTab({
    required this.isAdmin,
    required this.dramas,
    required this.onOpenDetail,
    required this.onEdit,
  });

  final bool isAdmin;
  final List<Drama> dramas;
  final ValueChanged<Drama> onOpenDetail;
  final ValueChanged<Drama> onEdit;

  @override
  Widget build(BuildContext context) {
    final popular = dramas.take(2).toList();
    final recent = dramas.skip(2).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      children: [
        Row(
          children: [
            Text(
              'hello, ${isAdmin ? 'admin' : 'minjung'}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF0F4A5D)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _FakeSearchField(),
        const SizedBox(height: 16),
        const Text(
          'Select Categories',
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Wrap(
          spacing: 8,
          children: [
            _CategoryChip(label: 'All', active: true),
            _CategoryChip(label: 'Thriller'),
            _CategoryChip(label: 'Action'),
            _CategoryChip(label: 'Horor'),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Popular drama',
          style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: popular.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final drama = popular[index];
              return _DramaCard(
                drama: drama,
                onTap: () => onOpenDetail(drama),
                onEdit: isAdmin ? () => onEdit(drama) : null,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Recently added',
          style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          const _EmptyCard(text: 'Belum ada data recently added.')
        else
          ...recent.map(
            (drama) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DramaRow(
                drama: drama,
                onTap: () => onOpenDetail(drama),
                onEdit: isAdmin ? () => onEdit(drama) : null,
              ),
            ),
          ),
      ],
    );
  }
}

class _SimpleListTab extends StatelessWidget {
  const _SimpleListTab({
    required this.title,
    required this.dramas,
    required this.onOpenDetail,
  });

  final String title;
  final List<Drama> dramas;
  final ValueChanged<Drama> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: dramas.isEmpty
                ? const _EmptyCard(text: 'Belum ada item.')
                : ListView.separated(
                    itemCount: dramas.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final drama = dramas[index];
                      return _DramaRow(
                        drama: drama,
                        onTap: () => onOpenDetail(drama),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.isAdmin, required this.onLogout});

  final bool isAdmin;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 14),
        const CircleAvatar(
          radius: 56,
          backgroundColor: Colors.white54,
          child: Icon(Icons.person, size: 62, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            isAdmin ? 'Admin' : 'Minjung',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'admin@mydrama.com',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        const SizedBox(height: 22),
        if (isAdmin)
          const _ProfileAction(title: 'Edit KDrama', subtitle: 'Manage and update KDrama'),
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: onLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B6588),
            foregroundColor: Colors.white,
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

class _DramaCard extends StatelessWidget {
  const _DramaCard({
    required this.drama,
    required this.onTap,
    this.onEdit,
  });

  final Drama drama;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 230,
        decoration: BoxDecoration(
          color: const Color(0xFFD2E5E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DramaPoster(assetPath: drama.posterAsset, width: 210, height: 180),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      drama.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102D3C),
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DramaRow extends StatelessWidget {
  const _DramaRow({
    required this.drama,
    required this.onTap,
    this.onEdit,
  });

  final Drama drama;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFFD2E5E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              DramaPoster(assetPath: drama.posterAsset, width: 90, height: 70),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(drama.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${drama.year} • ${drama.genre}'),
                    Text('★ ${drama.rating}'),
                  ],
                ),
              ),
              if (onEdit != null)
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FakeSearchField extends StatelessWidget {
  const _FakeSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'search for a KDrama',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Icon(Icons.search, color: Colors.white70),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.active = false});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      side: BorderSide(color: active ? Colors.transparent : Colors.white70),
      labelStyle: TextStyle(color: Colors.white, fontWeight: active ? FontWeight.bold : null),
      backgroundColor: active ? const Color(0xFF0B6588) : Colors.transparent,
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF608B95),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_square, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD2E5E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF213B47))),
    );
  }
}
