package org.andy.demokafkatrackingservice.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.andy.demokafkatrackingservice.message.DispatchCompleted;
import org.andy.demokafkatrackingservice.message.DispatchPreparing;
import org.andy.demokafkatrackingservice.message.OrderCreated;
import org.andy.demokafkatrackingservice.message.OrderDispatched;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class DispatchService {

    private static final String DISPATCH_TRACKING_TOPIC = "dispatch.tracking";

    private static final String ORDER_DISPATCH_TOPIC = "order.dispatched";

    private static final UUID APPLICATION_ID = UUID.randomUUID();

    private final KafkaTemplate<String, Object> kafkaProducer;

    public void process(String key, OrderCreated payload) throws Exception {

        DispatchPreparing dispatchPreparing = DispatchPreparing.builder()
                .orderId(payload.getOrderId())
                .build();

        kafkaProducer.send(DISPATCH_TRACKING_TOPIC, key, dispatchPreparing).get();

        OrderDispatched orderDispatched = OrderDispatched.builder()
                .orderId(payload.getOrderId())
                .processedById(APPLICATION_ID)
                .notes("Dispatched: " + payload.getItem())
                .build();

        kafkaProducer.send(ORDER_DISPATCH_TOPIC, key, orderDispatched).get();

        DispatchCompleted dispatchCompleted = DispatchCompleted.builder()
                .orderId(payload.getOrderId())
                .dispatchedDate(LocalDate.now().toString())
                .build();

        kafkaProducer.send(DISPATCH_TRACKING_TOPIC, key, dispatchCompleted).get();

        log.info("Send messages: orderId: {}, processedById: {}", payload.getOrderId(), APPLICATION_ID);
    }


}
