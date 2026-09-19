class ScenarioConfig {
  final String id;
  final String number;
  final String title;
  final String slug;
  final String subtitle;
  final String keywordsHint;
  final String roleTitle;
  final String roleHint;
  final String voiceQuestionTitle;
  final String additionalNotesHint;

  const ScenarioConfig({
    required this.id,
    required this.number,
    required this.title,
    required this.slug,
    required this.subtitle,
    required this.keywordsHint,
    required this.roleTitle,
    required this.roleHint,
    required this.voiceQuestionTitle,
    required this.additionalNotesHint,
  });

  static const List<ScenarioConfig> all = [
    ScenarioConfig(
      id: '01',
      number: '01',
      title: 'Job Interview',
      slug: 'job_interview',
      subtitle:
          'Tell SpeechPro about your interview. Add a few keywords below about why you want to win this job.',
      keywordsHint:
          'I have a job interview coming up and I want to walk in with complete authority and conviction.',
      roleTitle: 'What role are you applying for?',
      roleHint: 'e.g. Head of Marketing at Unilever',
      voiceQuestionTitle:
          'In your own words — why do you want this role and why are you the right person for it?',
      additionalNotesHint:
          'Use the text below to add a few additional sentences why you feel you are the best person to win this',
    ),
    ScenarioConfig(
      id: '02',
      number: '02',
      title: 'Investor Pitch',
      slug: 'investor_pitch',
      subtitle:
          'Tell SpeechPro about your pitch. Add a few keywords below about your venture and what you are asking for.',
      keywordsHint:
          'I am pitching our Seed round to VCs and want to convey vision, traction, and decisive leadership.',
      roleTitle: 'What is your role or venture?',
      roleHint: 'e.g. Founder & CEO pitching Seed Round',
      voiceQuestionTitle:
          'In your own words — what is your pitch and why should investors back you?',
      additionalNotesHint:
          'Use the text below to add key traction metrics or venture context',
    ),
    ScenarioConfig(
      id: '03',
      number: '03',
      title: 'Promotion or Pay Rise',
      slug: 'promotion_pay_rise',
      subtitle:
          'Tell SpeechPro about your promotion case. Add a few keywords below about why you deserve this step up.',
      keywordsHint:
          'I am building my promotion case to Director level and want to communicate strategic value without sounding entitled.',
      roleTitle: 'What is your current role and target level?',
      roleHint: 'e.g. Senior Lead targeting Director of Product',
      voiceQuestionTitle:
          'In your own words — why have you earned this promotion and what impact will you deliver?',
      additionalNotesHint:
          'Use the text below to add accomplishments or context on your impact',
    ),
    ScenarioConfig(
      id: '04',
      number: '04',
      title: 'TED Talk or Presentation',
      slug: 'ted_talk_presentation',
      subtitle:
          'Tell SpeechPro about your talk. Add a few keywords below about your core message and audience.',
      keywordsHint:
          'I am presenting a keynote on AI and human connection and want to captivate the audience from my opening line.',
      roleTitle: 'What is your speaking topic or presentation?',
      roleHint: 'e.g. Keynote Speaker addressing 500 industry leaders',
      voiceQuestionTitle:
          'In your own words — what is your core message and why must this audience hear it?',
      additionalNotesHint:
          'Use the text below to add details about your talk structure or audience',
    ),
    ScenarioConfig(
      id: '05',
      number: '05',
      title: 'Sales or Client Meeting',
      slug: 'sales_client_meeting',
      subtitle:
          'Tell SpeechPro about your meeting. Add a few keywords below about your client and the deal.',
      keywordsHint:
          'I am pitching a strategic deal to executive stakeholders and want to command respect and drive decision-making.',
      roleTitle: 'What is your role and who are you meeting?',
      roleHint: 'e.g. Enterprise Account Director meeting VP of Technology',
      voiceQuestionTitle:
          'In your own words — why is your solution the right choice for the client?',
      additionalNotesHint:
          'Use the text below to add details about deal terms or objections',
    ),
    ScenarioConfig(
      id: '06',
      number: '06',
      title: 'Podcast or Camera',
      slug: 'podcast_camera',
      subtitle:
          'Tell SpeechPro about your appearance. Add a few keywords below about the topic and audience.',
      keywordsHint:
          'I am appearing on a leading industry podcast and want my insights to sound punchy, memorable, and natural.',
      roleTitle: 'What show or topic are you appearing for?',
      roleHint: 'e.g. Featured Guest on Tech Founder Podcast',
      voiceQuestionTitle:
          'In your own words — what perspective do you bring and why does it resonate?',
      additionalNotesHint:
          'Use the text below to add context on discussion topics',
    ),
    ScenarioConfig(
      id: '07',
      number: '07',
      title: 'Social Confidence',
      slug: 'social_confidence',
      subtitle:
          'Tell SpeechPro about your situation. Add a few keywords below about where you want more confidence.',
      keywordsHint:
          'I want to stop overthinking in group social gatherings and speak with warmth, ease, and presence.',
      roleTitle: 'What social situation are you preparing for?',
      roleHint: 'e.g. Executive dinners and high-profile networking events',
      voiceQuestionTitle:
          'In your own words — how do you want to feel and show up in social settings?',
      additionalNotesHint:
          'Use the text below to add context on what holds you back',
    ),
    ScenarioConfig(
      id: '08',
      number: '08',
      title: 'English and Pronunciation',
      slug: 'english_pronunciation',
      subtitle:
          'Tell SpeechPro about your goals. Add a few keywords below about your speaking clarity.',
      keywordsHint:
          'English is my second language and I want to eliminate hesitation and speak with crisp articulation.',
      roleTitle: 'What is your professional communication setting?',
      roleHint: 'e.g. International executive leading English-speaking teams',
      voiceQuestionTitle:
          'In your own words — what are your pronunciation and speaking clarity goals?',
      additionalNotesHint:
          'Use the text below to add specific pronunciation or vocabulary challenges',
    ),
    ScenarioConfig(
      id: '09',
      number: '09',
      title: 'Difficult Conversation',
      slug: 'difficult_conversation',
      subtitle:
          'Tell SpeechPro about the situation. Add a few keywords below about what you need to address.',
      keywordsHint:
          'I have a high-stakes conversation and need to be direct, calm, and constructive without being defensive.',
      roleTitle: 'What is the situation or relationship?',
      roleHint: 'e.g. Addressing performance issues with a senior colleague',
      voiceQuestionTitle:
          'In your own words — what is the key message you need to deliver with clarity?',
      additionalNotesHint:
          'Use the text below to add any sensitive background dynamics',
    ),
    ScenarioConfig(
      id: '10',
      number: '10',
      title: 'Negotiation',
      slug: 'negotiation',
      subtitle:
          'Tell SpeechPro about your negotiation. Add a few keywords below about what is on the table.',
      keywordsHint:
          'I want to hold firm on terms without appearing combative and use strategic silence to protect leverage.',
      roleTitle: 'What are you negotiating?',
      roleHint: 'e.g. Vendor contract renewal or executive compensation package',
      voiceQuestionTitle:
          'In your own words — what outcome do you want and where is your leverage?',
      additionalNotesHint:
          'Use the text below to add negotiation priorities or walk-away points',
    ),
    ScenarioConfig(
      id: '11',
      number: '11',
      title: 'Leading a Team',
      slug: 'leading_team',
      subtitle:
          'Tell SpeechPro about your team. Add a few keywords below about the direction you want to set.',
      keywordsHint:
          'I want my team to feel inspired, accountable, and confident in my vision during times of change.',
      roleTitle: 'What leadership role or team do you lead?',
      roleHint: 'e.g. Engineering Director leading 35 cross-functional members',
      voiceQuestionTitle:
          'In your own words — what is your vision and standard for the team?',
      additionalNotesHint:
          'Use the text below to add team challenges or milestones',
    ),
    ScenarioConfig(
      id: '12',
      number: '12',
      title: 'Board or Executive Meeting',
      slug: 'board_executive_meeting',
      subtitle:
          'Tell SpeechPro about your meeting. Add a few keywords below about your key agenda.',
      keywordsHint:
          'I need to present strategic updates to our board of directors with extreme conciseness and composure under pressure.',
      roleTitle: 'What is the meeting or your presentation?',
      roleHint: 'e.g. Presenting annual budget and strategy to Board of Directors',
      voiceQuestionTitle:
          'In your own words — what decision or endorsement do you need from the board?',
      additionalNotesHint:
          'Use the text below to add anticipated questions or key metrics',
    ),
    ScenarioConfig(
      id: '13',
      number: '13',
      title: 'TV, Radio or Press',
      slug: 'tv_radio_press',
      subtitle:
          'Tell SpeechPro about your media appearance. Add a few keywords below about the key points.',
      keywordsHint:
          'I have a live broadcast interview and must deliver 10-second soundbites that land clearly without filler words.',
      roleTitle: 'What is the media outlet or broadcast?',
      roleHint: 'e.g. Live television news panel on industry market analysis',
      voiceQuestionTitle:
          'In your own words — what is the headline message you want the audience to remember?',
      additionalNotesHint:
          'Use the text below to add potential tricky press questions',
    ),
    ScenarioConfig(
      id: '14',
      number: '14',
      title: 'Wedding Speech or Toast',
      slug: 'wedding_speech_toast',
      subtitle:
          'Tell SpeechPro about the occasion. Add a few keywords below about who you are celebrating.',
      keywordsHint:
          'I want to deliver a heartfelt, humorous, and memorable speech without getting choked up or rambling.',
      roleTitle: 'What is your role at the wedding?',
      roleHint: 'e.g. Best Man or Maid of Honor speaking to 120 guests',
      voiceQuestionTitle:
          'In your own words — what do you want to express to the couple and guests?',
      additionalNotesHint:
          'Use the text below to add stories or tone preference',
    ),
    ScenarioConfig(
      id: '15',
      number: '15',
      title: 'Training or Teaching',
      slug: 'training_teaching',
      subtitle:
          'Tell SpeechPro about your session. Add a few keywords below about what you are teaching.',
      keywordsHint:
          'I want to keep students engaged, explain complex concepts simply, and project authority as an instructor.',
      roleTitle: 'What subject or class are you teaching?',
      roleHint: 'e.g. Lead Instructor teaching data architecture workshop',
      voiceQuestionTitle:
          'In your own words — what transformation do you want your learners to achieve?',
      additionalNotesHint:
          'Use the text below to add class format or student background',
    ),
    ScenarioConfig(
      id: '16',
      number: '16',
      title: 'Virtual and Zoom Presence',
      slug: 'virtual_zoom_presence',
      subtitle:
          'Tell SpeechPro about your calls. Add a few keywords below about where you want more impact.',
      keywordsHint:
          'I want to command attention on video calls, maintain eye engagement, and avoid fading into the background.',
      roleTitle: 'What virtual meetings do you lead?',
      roleHint: 'e.g. Remote Product Lead conducting distributed syncs',
      voiceQuestionTitle:
          'In your own words — how do you want to project presence across the screen?',
      additionalNotesHint:
          'Use the text below to add setup challenges or meeting types',
    ),
    ScenarioConfig(
      id: '17',
      number: '17',
      title: 'Overcoming Speaking Anxiety',
      slug: 'overcoming_speaking_anxiety',
      subtitle:
          'Tell SpeechPro about your speaking anxiety. Add a few keywords below about what triggers it.',
      keywordsHint:
          'My heart races when I have to speak unexpectedly. I want to ground my breath, calm my voice, and stay steady.',
      roleTitle: 'In what situations do you feel speaking anxiety?',
      roleHint: 'e.g. Speaking in front of senior leaders or speaking off-the-cuff',
      voiceQuestionTitle:
          'In your own words — how will mastering vocal composure change your life or career?',
      additionalNotesHint:
          'Use the text below to add physical sensations or triggers you face',
    ),
    ScenarioConfig(
      id: '18',
      number: '18',
      title: 'Something Else',
      slug: 'something_else',
      subtitle:
          'Tell SpeechPro about your communication goal. Add a few keywords below about what you want to achieve.',
      keywordsHint:
          'I want to elevate my vocal delivery, build commanding presence, and speak with impact in all high-stakes moments.',
      roleTitle: 'What is your situation or goal?',
      roleHint: 'e.g. Professional preparing for a unique speaking challenge',
      voiceQuestionTitle:
          'In your own words — describe what success looks like for you here',
      additionalNotesHint:
          'Use the text below to add any other details or goals',
    ),
  ];

  static ScenarioConfig findByTitleOrId(String titleOrId) {
    final clean = titleOrId.trim().toLowerCase();
    for (final item in all) {
      if (item.id.toLowerCase() == clean ||
          item.title.toLowerCase() == clean ||
          item.slug.toLowerCase() == clean) {
        return item;
      }
    }
    return all.first; // Default to Job Interview
  }
}
