import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  int currentStep = 0;
  bool isCompleted = false;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final address = TextEditingController();
  final postcode = TextEditingController();

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: const Text('Account'),
            content: Column(
              // Removed the Container
              children: [
                TextFormField(
                    controller: firstName,
                    decoration: const InputDecoration(labelText: 'Name')),
                TextFormField(
                    controller: lastName,
                    decoration: const InputDecoration(labelText: 'Last Name'))
              ],
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text('Address'),
            content: Column(
              // Removed the Container
              children: [
                TextFormField(
                    controller: address,
                    decoration: const InputDecoration(labelText: 'Address')),
                TextFormField(
                    controller: postcode,
                    decoration: const InputDecoration(labelText: 'Postcode'))
              ],
            )),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('Complete'),
          content: const Column(
            children: [
              Text('Thank you for completing the form!'),
            ],
          ), // Add any necessary widgets here or keep it empty
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reporting Crime'),
          centerTitle: true,
        ),
        body: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.red),
            ),
            child: Stepper(
              type: StepperType.vertical,
              steps: getSteps(),
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                if (isLastStep) {
                  setState(() => isCompleted = true);

                  logger.i('Completed');
                } else {
                  setState(() => currentStep += 1);
                  logger.i(currentStep);
                }
              },
              onStepTapped: (step) => setState(() => currentStep = step),
              onStepCancel: currentStep == 0
                  ? null
                  : () => setState(() => currentStep -= 1),
              controlsBuilder: (context, controls) {
                final isLastStep = currentStep == getSteps().length - 1;
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controls.onStepContinue,
                          child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (currentStep != 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controls.onStepCancel,
                            child: const Text('Back'),
                          ),
                        )
                    ],
                  ),
                );
              },
            )));
  }
}
