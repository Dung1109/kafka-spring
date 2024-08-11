package org.andy.demokafkatrackingservice.handler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.andy.demokafkatrackingservice.exception.NotRetryableException;
import org.andy.demokafkatrackingservice.exception.RetryableException;
import org.andy.demokafkatrackingservice.message.OrderCreated;
import org.andy.demokafkatrackingservice.service.DispatchService;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

@Component
@Slf4j
@RequiredArgsConstructor
public class OrderCreatedHandler {

    private final DispatchService dispatchService;

    @KafkaListener(
            id = "orderConsumerClient",
            topics = "order.created",
            groupId = "dispatch.order.created.consumer",
            containerFactory = "kafkaListenerContainerFactory"
    )
    public void listen(@Header(KafkaHeaders.RECEIVED_PARTITION) Integer partition, @Header(KafkaHeaders.RECEIVED_KEY) String key, @Payload OrderCreated payload) {
        log.info("Received message: partition: {} - key: {} - payload: {}", partition, key, payload);
        try {
            dispatchService.process(key, payload);
        } catch (RetryableException e) {
            log.warn("Retryable exception: {}", e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("NotRetryable exception: {}", e.getMessage());
            throw new NotRetryableException(e);
        }
    }
}
