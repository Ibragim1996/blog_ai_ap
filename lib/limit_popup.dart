import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // нужен для шаринга
import 'usage_limiter.dart'; // импортируй свой UsageLimiter (или как у тебя называется лимитер)

void showLimitPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.hourglass_bottom_rounded,
                size: 48,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              const Text(
                "You’ve completed your 10 AI tasks for today.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Hopefully, you recorded something meaningful — maybe a few videos for your social media, or just moments to keep for yourself.\n\n"
                "You’ll get 10 more tasks tomorrow — fresh, new, and ready to challenge you again.\n\n"
                "Thanks for being here.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text("Got it"),
              ),
              const SizedBox(height: 10),
              // Новая кнопка Invite
              ElevatedButton.icon(
                onPressed: () async {
                  // Генерируй свою реферальную ссылку или просто ссылку на приложение
                  const referralLink = "https://yourapp.com/?ref=YOURCODE";
                  await Share.share(
                    "Join me on GoGine! Get your daily creative challenges and unique tasks. Try it here: $referralLink",
                  );
                  // Дать бонус (+5)
                  await UsageLimiter.addBonusTasks(5);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You’ve got 5 extra tasks today!"),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text("Invite & Get 5 More Tasks"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
