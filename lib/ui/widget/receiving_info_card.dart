import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/commodity/receiving_info.dart';

class ReceivingInfoCard extends StatelessWidget {
  final ReceivingInfo receivingInfo;

  const ReceivingInfoCard({Key? key, required this.receivingInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.orange,),
            const SizedBox(width: 8.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        receivingInfo.receiver,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12.0,),
                      Text(
                        receivingInfo.phone,
                        // style: const TextStyle(
                        //   fontSize: 16.0,
                        //   fontWeight: FontWeight.bold,
                        // ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0,),
                  Text(
                    receivingInfo.detailedAddress,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0,),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                18.67))),
                    side: MaterialStateProperty.all(
                      const BorderSide(
                          color: Colors.grey,
                          width: 0.67),
                    ),
                    backgroundColor:
                    MaterialStateProperty.all(
                        Colors.transparent)),
                child: const Text(
                  '修改',
                ),
                onPressed: () {}
            ),
            const SizedBox(width: 8.0,),
          ],
        ),
      ),
    );
  }
}