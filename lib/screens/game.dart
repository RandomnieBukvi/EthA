import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lets_go/Utils.dart';
import 'package:lets_go/all_weapons.dart';
import 'package:lets_go/screens/inventory.dart';
import 'package:math_expressions/math_expressions.dart';

import '../constans.dart';

bool notepadIsShowing = false;
bool memoryIsShowing = false;
bool mathProblemSheetShowing = false;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  showButtons() {
    setState(() {
      leftButtonOffset = MediaQuery.of(context).size.width / 4 - 10;
      rightButtonOffset = MediaQuery.of(context).size.width / 4 - 10;
    });
  }

  hideButtons() {
    setState(() {
      leftButtonOffset = -MediaQuery.of(context).size.width / 4;
      rightButtonOffset = -MediaQuery.of(context).size.width / 4;
    });
  }

  addWeaponToList(String key) {
    setState(() {
      chosedWeaponsBuf.add(WeaponBoxGame(
        onTap: (sindex) {
          setState(() {
            chosedWeaponsBuf.removeAt(int.parse(sindex));
            chosedWeaponsBuf.forEach((element) {
              if (element.index! >= int.parse(sindex)) {
                element.index = element.index! - 1;
              }
            });
          });
        },
        wkey: key,
        index: chosedWeaponsBuf.length,
      ));
    });
  }

  doneButtonAction() {
    MathProblem.operationsList = chosedWeaponsBuf.map((e) => e.wkey).toList();
    MathProblem.makeProblem();
    MathProblem.evaluateProblem();
    setState(() {
      notepadOffsetGame = -500;
      notepadIsShowing = false;
    });
    Future.delayed(Duration(milliseconds: 150), () {
      setState(() {
        mathProblemSheetShowing = false;
        mathProblemSheetOffset = 0;
      });
    });
  }

  mathProblemSolvedCorrect(){
    setState(() {
      memory.add(ChosedWeaponsOrder(chosedOrder: chosedWeaponsBuf));
      chosedWeaponsBuf = [];
      mathProblemSheetOffset = -500;
    });
    Future.delayed(Duration(milliseconds: 75), (){
      showButtons();
    });
  }

  mathProblemSolvedWrong(){
    setState(() {
      chosedWeaponsBuf = [];
      mathProblemSheetOffset = -500;
    });
    Future.delayed(Duration(milliseconds: 75), (){
      showButtons();
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () => showButtons());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    rightButtonOffset = -50;
    rightButtonOffset = -50;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            notepadIsShowing && chosedWeaponsBuf.isNotEmpty
                ? FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: doneButtonAction,
                    elevation: 0,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    backgroundColor: kPrimaryColor,
                  )
                : Container(),
            notepadIsShowing && chosedWeaponsBuf.isNotEmpty
                ? SizedBox(
                    height: 40,
                  )
                : Container(),
            notepadIsShowing || memoryIsShowing
                ? FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      if (notepadIsShowing) {
                        notepadIsShowing = false;
                        setState(() {
                          notepadOffsetGame = -500;
                        });
                      } else {
                        memoryIsShowing = false;
                        setState(() {
                          memoryOffset = -500;
                        });
                      }
                      Future.delayed(Duration(milliseconds: 75), () {
                        setState(() {
                          showButtons();
                        });
                      });
                    },
                    elevation: 0,
                    child: Icon(
                      Icons.keyboard_double_arrow_down_sharp,
                      color: Colors.white,
                    ),
                    backgroundColor: kPrimaryColor,
                  )
                : Container()
          ]),
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
        ),
        Column(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  color: Colors.blue,
                )),
            Flexible(
                flex: 1,
                child: Container(
                  color: Colors.greenAccent,
                )),
          ],
        ),
        AnimatedPositioned(
          curve: Curves.ease,
          duration: Duration(milliseconds: 150),
          left: leftButtonOffset,
          bottom: MediaQuery.of(context).size.height / 4 -
              MediaQuery.of(context).size.width / 8,
          child: gameButton(
              context: context,
              icon: Icon(Icons.history),
              onTap: () {
                memoryIsShowing = true;
                hideButtons();
                Future.delayed(Duration(milliseconds: 75), () {
                  setState(() {
                    memoryOffset = 0;
                  });
                });
              }),
        ),
        AnimatedPositioned(
          curve: Curves.ease,
          duration: Duration(milliseconds: 150),
          right: rightButtonOffset,
          bottom: MediaQuery.of(context).size.height / 4 -
              MediaQuery.of(context).size.width / 8,
          child: gameButton(
              context: context,
              icon: Icon(Icons.book),
              onTap: () {
                notepadIsShowing = true;
                hideButtons();
                Future.delayed(Duration(milliseconds: 75), () {
                  setState(() {
                    notepadOffsetGame = 0;
                  });
                });
              }),
        ),
        GameNotepad(
          onBoxTap: addWeaponToList,
        ),
        notepadOffsetGame == 0 ? ChosedWeaponsBuffer() : Container(),
        Memory(),
        MathProblemSheet(onCorrect: mathProblemSolvedCorrect, onWrong: mathProblemSolvedWrong,),
      ]),
    );
  }
}

double rightButtonOffset = -150;
double leftButtonOffset = -150;
Widget gameButton(
    {required BuildContext context,
    required Icon icon,
    required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
        height: MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 4,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Center(child: icon))),
  );
}

double notepadOffsetGame = -500;

class GameNotepad extends StatefulWidget {
  GameNotepad({super.key, required this.onBoxTap});
  Function(String) onBoxTap;
  @override
  State<GameNotepad> createState() => _GameNotepadState();
}

class _GameNotepadState extends State<GameNotepad> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.ease,
      right: (MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width / 1.4) /
          2,
      bottom: notepadOffsetGame,
      duration: Duration(milliseconds: 150),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 1.4,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            filterQuality: FilterQuality.none,
            fit: BoxFit.fill,
            image: AssetImage('assets/images/notepad.png'),
          )),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 27, right: 15, top: 15, bottom: 15),
            child: Wrap(
              spacing: 3,
              runSpacing: 3,
              children: notepad.keys
                  .map(
                      (key) => WeaponBoxGame(onTap: widget.onBoxTap, wkey: key))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class WeaponBoxGame extends StatelessWidget {
  WeaponBoxGame(
      {super.key, required this.onTap, required this.wkey, this.index});
  Function(String) onTap;
  String wkey;
  int? index;

  tap() {
    if (index != null) {
      onTap(index!.toString());
    } else {
      onTap(wkey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: SizedBox(
        height: 75,
        width: 75,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(weapons[wkey]!.operationSymbol,
                  style: TextStyle(fontSize: 45)),
            ),
          ),
        ),
      ),
    );
    ;
  }
}

List<WeaponBoxGame> chosedWeaponsBuf = [];

class ChosedWeaponsBuffer extends StatefulWidget {
  ChosedWeaponsBuffer({super.key});
  @override
  State<ChosedWeaponsBuffer> createState() => _ChosedWeaponsBufferState();
}

class _ChosedWeaponsBufferState extends State<ChosedWeaponsBuffer> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: chosedWeaponsBuf.length < 5
          ? MediaQuery.of(context).size.width / 2 -
              chosedWeaponsBuf.length * 37.5
          : MediaQuery.of(context).size.width / 2 - 4 * 37.5,
      bottom: MediaQuery.of(context).size.height / 1.8,
      child: chosedWeaponsBuf.length < 5
          ? Row(
              children: chosedWeaponsBuf,
            )
          : SizedBox(
              height: 75,
              width: 75 * 4,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: chosedWeaponsBuf,
                ),
              ),
            ),
    );
  }
}

class MathProblem {
  static List<String> operationsList = [];
  static String problem = '';
  static double answer = 0;
  static void makeProblem() {
    problem = '';
    answer = 0;
    var random = Random();
    String operation;
    int index;
    int previousNumber;
    int nowNumber;
    //Doing once
    index = random.nextInt(operationsList.length);
    operation = weapons[operationsList.elementAt(index)]!.operationSymbol;
    operationsList.removeAt(index);
    if (operation == '/') {
      previousNumber = _makeDividable('');
    } else {
      previousNumber = random.nextInt(100);
      nowNumber = random.nextInt(100);
      problem += previousNumber.toString() + operation + nowNumber.toString();
      previousNumber = nowNumber;
    }

    //then, maybe more
    while (operationsList.length > 0) {
      index = random.nextInt(operationsList.length);
      operation = weapons[operationsList.elementAt(index)]!.operationSymbol;
      operationsList.removeAt(index);
      if (operation == '/') {
        previousNumber = _makeDividable(previousNumber.toString());
      } else {
        nowNumber = random.nextInt(100);
        problem += operation + nowNumber.toString();
        previousNumber = nowNumber;
      }
    }
  }

  static void evaluateProblem() {
    answer =
        Parser().parse(problem).evaluate(EvaluationType.REAL, ContextModel());
    print(answer);
    
  }

  static int _makeDividable(String previousNumber) {
    problem = problem.substring(0, problem.length - previousNumber.length);
    int a = Random().nextInt(10) + 1;
    int b = Random().nextInt(10) + 1;
    problem += (a * b).toString() + '/' + b.toString();
    return b;
  }
}

double mathProblemSheetOffset = -500;

class MathProblemSheet extends StatefulWidget {
  MathProblemSheet({super.key, required this.onCorrect, required this.onWrong});
  void Function() onCorrect;
  void Function() onWrong;

  @override
  State<MathProblemSheet> createState() => _MathProblemSheetState();
}

class _MathProblemSheetState extends State<MathProblemSheet> {
  TextEditingController mathProblemAnswerField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.ease,
      right: (MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width / 1.2) /
          2,
      bottom: mathProblemSheetOffset,
      duration: Duration(milliseconds: 150),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: GridPaper(
                interval: 20,
                divisions: 1,
                subdivisions: 1,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        'assets/icons/weapons.png',
                        filterQuality: FilterQuality.none,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0x7FC3E8F3),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text(MathProblem.problem),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller: mathProblemAnswerField,
                            decoration: InputDecoration(
                              label: const Text('Answer'),
                              floatingLabelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  style: BorderStyle.none,
                                  width: 0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Flexible(
                        flex: 1,
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                                onPressed: () {
                                  if(double.parse(mathProblemAnswerField.text) == MathProblem.answer){
                                    Utils.showSnackBar(context: context, text: 'Correct!', color: Colors.green);
                                    widget.onCorrect();
                                    mathProblemAnswerField.clear();
                                    FocusManager.instance.primaryFocus!.unfocus();
                                  }else{
                                    Utils.showSnackBar(context: context, text: 'Wrong, ${MathProblem.answer}', color: Colors.red);
                                    widget.onWrong();
                                    mathProblemAnswerField.clear();
                                    FocusManager.instance.primaryFocus!.unfocus();
                                  }
                                }, child: Icon(Icons.done)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChosedWeaponsOrder extends StatelessWidget {
  ChosedWeaponsOrder({super.key, required this.chosedOrder});
  List<WeaponBoxGame> chosedOrder;
  @override
  Widget build(BuildContext context) {
    List<Widget> order = chosedOrder
        .map((e) => SizedBox(
              height: 37.5,
              width: 37.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                    child: Text(weapons[e.wkey]!.operationSymbol,
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ))
        .toList();
    return order.length < 8
        ? SizedBox(
            height: 37.5 + 16,
            width: order.length * 37.5 + 16,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(0x7FC3E8F3),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: order,
              ),
            ),
          )
        : SizedBox(
            height: 37.5 + 16,
            width: 7 * 37.5 + 16,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(0x7FC3E8F3),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.all(8),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: order,
                ),
              ),
            ),
          );
  }
}

double memoryOffset = -500;
List<ChosedWeaponsOrder> memory = [];

class Memory extends StatefulWidget {
  const Memory({super.key});

  @override
  State<Memory> createState() => _MemoryState();
}

class _MemoryState extends State<Memory> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.ease,
      right: (MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width / 1.2) /
          2,
      bottom: memoryOffset,
      duration: Duration(milliseconds: 150),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: GridPaper(
                interval: 20,
                divisions: 1,
                subdivisions: 1,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 40,
                  ),
                  Divider(
                    thickness: 2,
                    color: kPrimaryColor,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(spacing: 4, runSpacing: 4, children: memory),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
