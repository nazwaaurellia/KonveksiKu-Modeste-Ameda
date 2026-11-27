import 'package:flutter/material.dart';
import '../../core/files.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

/// Tautan "Butuh bantuan? Chat admin".
class HelpLink extends StatelessWidget {
  final Order? order;
  const HelpLink({this.order, super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: InkWell(
          onTap: () => go(context, ChatScreen(order: order)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const ChatIcon(size: 18),
              const SizedBox(width: 8),
              Text('Butuh bantuan? ', style: t(13, color: C.brown, w: FontWeight.w600)),
              Text('Chat admin',
                  style: t(13, color: C.brown, w: FontWeight.w800).copyWith(decoration: TextDecoration.underline)),
            ]),
          ),
        ),
      );
}

class _Msg {
  final String text, time;
  final bool me;
  final PickedFile? file;
  _Msg(this.text, this.time, this.me, {this.file});
}

class ChatScreen extends StatefulWidget {
  final Order? order;
  const ChatScreen({this.order, super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final input = TextEditingController();
  final scroll = ScrollController();
  final msgs = <_Msg>[];

  String _now() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}.${n.minute.toString().padLeft(2, '0')}';
  }

  void _send([String? text]) {
    final v = (text ?? input.text).trim();
    if (v.isEmpty) return;
    setState(() => msgs.add(_Msg(v, _now(), true)));
    input.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scroll.hasClients) scroll.animateTo(scroll.position.maxScrollExtent + 80, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  Future<void> _attach() async {
    final f = await pickFile();
    if (f == null) return;
    setState(() => msgs.add(_Msg('', _now(), true, file: f)));
  }

  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.fromLTRB(4, 6, 16, 6),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: C.ink.withOpacity(.08)))),
                child: Row(children: [
                  IconButton(onPressed: () => Navigator.maybePop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 22)),
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: C.brown,
                    child: Text('MA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Modeste Ameda', style: t(16, w: FontWeight.w800)),
                    Text('Online', style: t(12, color: C.green, w: FontWeight.w700)),
                  ]),
                ]),
              ),
              Expanded(
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  children: [
                    if (o != null)
                      Box(
                        child: Row(children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(o.title, style: t(14, w: FontWeight.w800)),
                              Text('#${o.id} · ${o.qty} pcs', style: t(11, color: C.muted)),
                            ]),
                          ),
                          Tag(o.label),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right, color: C.ink),
                        ]),
                      ),
                    if (msgs.isNotEmpty) Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(color: C.sand, borderRadius: BorderRadius.circular(12)),
                        child: Text('Hari ini', style: t(11, w: FontWeight.w700)),
                      ),
                    ),
                    if (msgs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Text('Belum ada pesan.\nTulis pesan atau pilih pertanyaan cepat di bawah.',
                            textAlign: TextAlign.center, style: t(13, color: C.muted).copyWith(height: 1.5)),
                      ),
                    for (final m in msgs) _Bubble(m),
                  ],
                ),
              ),
              SizedBox(
                height: 54,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    for (final x in ['Kapan selesai?', 'Ubah desain', 'Masalah pembayaran'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OutlinedButton(
                          onPressed: () => _send(x),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: C.brown),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(x, style: t(12, color: C.brown, w: FontWeight.w700)),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: C.sand, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: _attach,
                      icon: const Icon(Icons.attach_file, color: C.brown, size: 22),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: input,
                      onSubmitted: (_) => _send(),
                      style: t(13),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: t(13, color: C.muted),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: Color(0xFFE6D7B5))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: C.brown)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: C.brown, shape: BoxShape.circle),
                    child: IconButton(onPressed: _send, icon: const Icon(Icons.send_outlined, color: Colors.white, size: 20)),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _Msg m;
  const _Bubble(this.m);
  @override
  Widget build(BuildContext context) => Align(
        alignment: m.me ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: BoxDecoration(
            color: m.me ? C.brown : Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (m.file != null)
              (m.file!.isImage && m.file!.bytes != null)
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(m.file!.bytes!, width: 200, fit: BoxFit.cover))
                  : Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.insert_drive_file_outlined, size: 20, color: m.me ? Colors.white : C.brown),
                      const SizedBox(width: 8),
                      Flexible(child: Text(m.file!.name, style: t(13, color: m.me ? Colors.white : C.ink, w: FontWeight.w600))),
                    ]),
            if (m.text.isNotEmpty) Text(m.text, style: t(14, color: m.me ? Colors.white : C.ink, w: m.me ? FontWeight.w600 : FontWeight.w500)),
            const SizedBox(height: 4),
            Text(m.time, style: t(11, color: m.me ? Colors.white70 : C.muted)),
          ]),
        ),
      );
}
