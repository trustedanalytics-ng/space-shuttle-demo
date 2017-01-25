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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.trustedanalytics.scoringengine.WebScoringEngine;

@Configuration
@Profile({"atk-scoring", "web-scoring"})
public class WebScoringEngineConfig {

    private static final Logger LOG = LoggerFactory.getLogger(WebScoringEngineConfig.class);

    @Value("${scoring.url}")
    private String scoringEngineUrl;

    @Bean
    protected WebScoringEngine webScoringEngine() {
        LOG.info("Creating WebScoringEngine");
        return new WebScoringEngine(scoringEngineUrl);
    }

}
