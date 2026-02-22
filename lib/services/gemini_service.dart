import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GeminiService(this.apiKey)
    : _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.6,
          topP: 0.9,
          maxOutputTokens: 700,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(
            HarmCategory.sexuallyExplicit,
            HarmBlockThreshold.medium,
          ),
          SafetySetting(
            HarmCategory.dangerousContent,
            HarmBlockThreshold.medium,
          ),
        ],
      );

  final String apiKey;
  final GenerativeModel _model;

  /// Creates a chat session with a Sri Lanka-only tourism persona.
  ChatSession startSriLankaTourismChat() {
    final history = <Content>[Content.text(_systemSriLankaPrompt)];
    return _model.startChat(history: history);
  }

  static const String _systemSriLankaPrompt = """
You are "Traamp Assistant" inside a Sri Lanka tourism app.

SCOPE RULES (STRICT):
- Only suggest places, itineraries, guides, foods, and travel tips inside Sri Lanka.
- If user asks about other countries, politely say you only support Sri Lanka and offer Sri Lanka alternatives.

STYLE:
- Friendly, short, practical. Use bullet points.
- Always include: best time to go, approximate duration, and local transport tip.
- Ask 1-2 quick questions if you need details (budget, days, interests, starting city).

SAFETY:
- Don’t invent exact prices or phone numbers. Give approximate ranges and advise checking live rates.
- If something is uncertain, say so.

OUTPUT FORMAT:
- Title line
- 3–7 bullet points
- Optional: “If you tell me X, I can personalize it.”
""";
}
