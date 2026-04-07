import 'package:flutter/material.dart';

import '../models/drama.dart';

class DramaFormResult {
  const DramaFormResult({
    required this.title,
    required this.year,
    required this.rating,
    required this.genre,
    required this.tags,
    required this.synopsis,
    required this.posterAsset,
  });

  final String title;
  final int year;
  final double rating;
  final String genre;
  final List<String> tags;
  final String synopsis;
  final String posterAsset;
}

class DramaFormScreen extends StatefulWidget {
  const DramaFormScreen({super.key, this.initialDrama});

  final Drama? initialDrama;

  bool get isEditMode => initialDrama != null;

  @override
  State<DramaFormScreen> createState() => _DramaFormScreenState();
}

class _DramaFormScreenState extends State<DramaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  final _synopsisCtrl = TextEditingController();
  final _posterCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final drama = widget.initialDrama;
    if (drama != null) {
      _titleCtrl.text = drama.title;
      _yearCtrl.text = drama.year.toString();
      _ratingCtrl.text = drama.rating.toString();
      _genreCtrl.text = drama.genre;
      _tagsCtrl.text = drama.tags.join(', ');
      _synopsisCtrl.text = drama.synopsis;
      _posterCtrl.text = drama.posterAsset;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _yearCtrl.dispose();
    _ratingCtrl.dispose();
    _genreCtrl.dispose();
    _tagsCtrl.dispose();
    _synopsisCtrl.dispose();
    _posterCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final result = DramaFormResult(
      title: _titleCtrl.text.trim(),
      year: int.parse(_yearCtrl.text.trim()),
      rating: double.parse(_ratingCtrl.text.trim()),
      genre: _genreCtrl.text.trim(),
      tags: tags,
      synopsis: _synopsisCtrl.text.trim(),
      posterAsset: _posterCtrl.text.trim(),
    );
    Navigator.pop(context, result);
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit KDrama' : 'Tambah KDrama'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _FormInput(label: 'Title', controller: _titleCtrl),
            _FormInput(
              label: 'Release year',
              controller: _yearCtrl,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (_requiredValidator(v) case final message?) return message;
                return int.tryParse(v!.trim()) == null ? 'Harus angka' : null;
              },
            ),
            _FormInput(
              label: 'Rating',
              controller: _ratingCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (_requiredValidator(v) case final message?) return message;
                final parsed = double.tryParse(v!.trim());
                if (parsed == null) return 'Format rating tidak valid';
                if (parsed < 0 || parsed > 10) return 'Masukkan 0 - 10';
                return null;
              },
            ),
            _FormInput(label: 'Genre', controller: _genreCtrl),
            _FormInput(
              label: 'Tags (pisahkan dengan koma)',
              controller: _tagsCtrl,
            ),
            _FormInput(
              label: 'Poster Asset',
              controller: _posterCtrl,
              hint: 'assets/images/nama_poster.jpg',
              validator: _requiredValidator,
            ),
            _FormInput(
              label: 'Synopsis',
              controller: _synopsisCtrl,
              minLines: 4,
              maxLines: 6,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B6588),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormInput extends StatelessWidget {
  const _FormInput({
    required this.label,
    required this.controller,
    this.hint,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator ?? (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF0F6F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
