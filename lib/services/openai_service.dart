import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  Future<String> getShortTask(String prompt) async {
    final openAIApiKey = dotenv.env['OPENAI_API_KEY'];
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "Reply in 2-3 lines, suitable for a mobile popup.",
            },
            {"role": "user", "content": prompt},
          ],
          "max_tokens": 60,
          "temperature": 1.4,
        }),
      );

      final body = jsonDecode(response.body);
      print('Ответ от OpenAI: $body'); // Debug info

      // Check for success and choices array
      if (response.statusCode == 200 &&
          body['choices'] != null &&
          body['choices'].isNotEmpty) {
        return body['choices'][0]['message']['content'];
      } else if (body['error'] != null) {
        // Error from OpenAI
        return 'AI Error: ${body['error']['message']}';
      } else {
        return 'AI Error: unknown response format.';
      }
    } catch (e) {
      print('Ошибка при запросе к OpenAI: $e');
      return 'AI Error: $e';
    }
  }
}
