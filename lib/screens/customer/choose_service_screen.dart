import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'new_order_step1_screen.dart';
import 'services.dart';

class ChooseServiceScreen extends StatefulWidget {
  const ChooseServiceScreen({super.key});
  @override
  State<ChooseServiceScreen> createState() => _ChooseServiceScreenState();
}

class _ChooseServiceScreenState extends State<ChooseServiceScreen> {
  int sel = 0;

  @override
  Widget build(BuildContext context) => Screen(
        title: 'Mau pesan apa?',
        bottom: Btn('Lanjut', () {
          kServices[sel].startDraft();
          go(context, const NewOrderStep1Screen());
        }),
        children: [
          Text('Pilih layanan dulu. Detail bahan dan desain diisi di langkah berikutnya.', style: t(13, color: C.muted)),
          const SizedBox(height: 14),
          for (final (i, s) in kServices.indexed)
            GestureDetector(
              onTap: () => setState(() => sel = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: sel == i ? C.brown : Colors.transparent, width: 2),
                  boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 14, offset: Offset(0, 4))],
                ),
                child: Row(children: [
                  SizedBox(width: 120, child: ServiceImage(s, radius: 14)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.title, style: t(16, w: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(s.sub, style: t(12, color: C.muted)),
                    ]),
                  ),
                  Icon(sel == i ? Icons.check_circle : Icons.circle_outlined, color: sel == i ? C.brown : C.muted),
                ]),
              ),
            ),
        ],
      );
}
