kafka-console-producer.sh --producer.config /opt/bitnami/kafka/config/producer.properties --bootstrap-server 127.0.0.1:9092 --topic order.created

kafka-console-producer.sh --producer.config /opt/bitnami/kafka/config/producer.properties --bootstrap-server 127.0.0.1:9092 --topic order.created --property parse.key=true --property key.separator=:

kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic order.created --property print.key=true --property key.separator=:

kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic order.dispatched --property print.key=true --property key.separator=:

kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic dispatch.tracking --property print.key=true --property key.separator=:

kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic tracking.status


"123":{"orderId":"185c465d-c5de-4a51-8356-b95cb25b2ead","item":"item-id-2"}
"345":{"orderId":"185c465d-c5de-4a51-8356-b95cb25b2ead","item":"item-id-10"}
"678":{"orderId":"185c465d-c5de-4a51-8356-b95cb25b2ead","item":"item-id-nam"}

kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --describe --topic order.created

kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --alter --topic order.created --partitions 5

kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --list

kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --describe --group dispatch.order.created.consumer

kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic order.created --from-beginning

kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic order.dispatched

kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic dispatch.tracking --from-beginning
kafka-console-consumer.sh --consumer.config /opt/bitnami/kafka/config/consumer.properties --bootstrap-server 127.0.0.1:9092 --topic tracking.status --from-beginning

{"orderId":"185c465d-c5de-4a51-8356-b95cb25b2ead","item":"item-id-2"}
{"orderId":"185c465d-c5de-4a51-8356-b95cb25b2ead","item":"item-id-10"}
{"orderId":"78927b1b-fe69-4757-9114-e3e83a868e84","item":"item-lala"}
{"orderId":"78927b1b","item":"item-lala"}


kafka-console-producer.sh --producer.config /opt/bitnami/kafka/config/producer.properties --bootstrap-server localhost:9092 --topic order.created
kafka-console-producer.sh --producer.config /opt/bitnami/kafka/config/producer.properties --bootstrap-server localhost:9092 --topic order.created --property parse.key=true --property key.separator=:
