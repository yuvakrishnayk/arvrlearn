class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  get explanation => null;
}

class SubjectQuestions {
  static List<Question> getChemistryQuestions() {
    return [
      Question(
        question: "What is water made of?",
        options: [
          "Air and soil",
          "Hydrogen and oxygen",
          "Sugar and salt",
          "Sun and clouds",
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Which of these is a liquid?",
        options: ["Rock", "Milk", "Chair", "Air"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "What happens to ice when it gets warm?",
        options: [
          "It gets bigger",
          "It melts into water",
          "It disappears",
          "It turns into air",
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Which sense helps us know if food is sweet or sour?",
        options: ["Sight", "Hearing", "Taste", "Touch"],
        correctAnswerIndex: 2,
      ),
      Question(
        question: "What do plants need to grow?",
        options: [
          "Water and sunlight",
          "Cake and ice cream",
          "Books and toys",
          "Cars and trucks",
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "Which of these is a color of the rainbow?",
        options: ["Brown", "Black", "Gray", "Purple"],
        correctAnswerIndex: 3,
      ),
      Question(
        question: "What do we breathe in to live?",
        options: ["Water", "Food", "Oxygen", "Dirt"],
        correctAnswerIndex: 2,
      ),
      Question(
        question: "What makes shadows?",
        options: ["Light", "Water", "Wind", "Sound"],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What do magnets attract?",
        options: ["Plastic", "Paper", "Metal", "Wood"],
        correctAnswerIndex: 2,
      ),
      Question(
        question: "Where does rain come from?",
        options: ["Trees", "Clouds", "Mountains", "Rivers"],
        correctAnswerIndex: 1,
      ),
    ];
  }

  static List<Question> getMathQuestions() {
    return [
      Question(
        question: "What is 3 + 2?",
        options: ["4", "5", "6", "7"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "How many sides does a square have?",
        options: ["3", "4", "5", "6"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "What number comes after 9?",
        options: ["8", "9", "10", "11"],
        correctAnswerIndex: 2,
      ),
      Question(
        question: "If you have 5 apples and eat 2, how many do you have left?",
        options: ["2", "3", "5", "7"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Which shape has three sides?",
        options: ["Circle", "Triangle", "Square", "Rectangle"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "What is 5 - 3?",
        options: ["1", "2", "3", "8"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Count the dots: ● ● ● ●. How many are there?",
        options: ["3", "4", "5", "6"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Which is the biggest number?",
        options: ["5", "2", "10", "7"],
        correctAnswerIndex: 2,
      ),
      Question(
        question: "How many fingers do you have on one hand?",
        options: ["4", "5", "6", "10"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "If today is Monday, what day was yesterday?",
        options: ["Tuesday", "Sunday", "Saturday", "Friday"],
        correctAnswerIndex: 1,
      ),
    ];
  }
}
