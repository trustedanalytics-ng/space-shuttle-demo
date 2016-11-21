/**
 * Copyright (c) 2016 Intel Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.trustedanalytics.config;

import com.google.common.base.Preconditions;
import kafka.consumer.Consumer;
import kafka.consumer.ConsumerConfig;
import kafka.consumer.KafkaStream;
import kafka.javaapi.consumer.ConsumerConnector;
import kafka.serializer.StringDecoder;
import kafka.utils.VerifiableProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.trustedanalytics.dataproviders.KafkaDataProvider;
import org.trustedanalytics.process.DataConsumer;
import org.trustedanalytics.process.FeatureVectorDecoder;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@Configuration
@Profile({"kafka-input", "services-all"})
public class KafkaDataProviderConfig {

    @Value("${gateway.zookeeper.uri}")
    private String zookeeperCluster;

    @Value("${gateway.pub.topic}")
    private String topicName;

    @Value("${consumer.group}")
    private String consumerGroup;

    @Bean
    protected KafkaStream<String, float[]> kafkaStream() {
        ConsumerConnector consumerConnector =
                Consumer.createJavaConsumerConnector(consumerConfig(zookeeperCluster, consumerGroup));
        Map<String, Integer> topicCounts = new HashMap<>();
        topicCounts.put(topicName, 1);
        VerifiableProperties emptyProps = new VerifiableProperties();
        StringDecoder keyDecoder = new StringDecoder(emptyProps);
        FeatureVectorDecoder valueDecoder = new FeatureVectorDecoder();
        Map<String, List<KafkaStream<String, float[]>>> streams =
                consumerConnector.createMessageStreams(topicCounts, keyDecoder, valueDecoder);
        List<KafkaStream<String, float[]>> streamsByTopic = streams.get(topicName);
        Preconditions.checkNotNull(streamsByTopic, String.format("Topic %s not found in streams map.", topicName));
        Preconditions.checkElementIndex(0, streamsByTopic.size(),
                String.format("List of streams of topic %s is empty.", topicName));
        return streamsByTopic.get(0);
    }

    @Bean(initMethod = "init")
    public KafkaDataProvider kafkaDataProvider(DataConsumer dataConsumer, KafkaStream<String, float[]> kafkaStream) {
        return new KafkaDataProvider(dataConsumer, kafkaStream);
    }

    private ConsumerConfig consumerConfig(String zookeeperCluster, String consumerGroup) {
        Properties props = new Properties();
        props.put("zookeeper.connect", zookeeperCluster);
        props.put("group.id", consumerGroup);
        props.put("zookeeper.session.timeout.ms", "1000");
        props.put("zookeeper.sync.time.ms", "200");
        props.put("auto.commit.interval.ms", "1000");
        return new ConsumerConfig(props);
    }

}
