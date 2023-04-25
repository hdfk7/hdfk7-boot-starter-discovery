package com.hdfk7.boot.starter.discovery.listener;

import cn.hutool.core.util.ReflectUtil;
import com.alibaba.nacos.api.naming.listener.Event;
import com.alibaba.nacos.api.naming.listener.NamingEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.cache.Cache;
import org.springframework.cache.caffeine.CaffeineCache;
import org.springframework.cloud.loadbalancer.cache.CaffeineBasedLoadBalancerCacheManager;
import org.springframework.cloud.loadbalancer.cache.LoadBalancerCacheManager;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentMap;

@Slf4j
@Component
@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.SERVLET)
public class LoadbalancerEventListener extends AbstractLoadbalancerEventListener {

    @SuppressWarnings("unchecked")
    @Override
    public void onEvent(Event event) {
        if (event instanceof NamingEvent e) {
            LoadBalancerCacheManager balancerCacheManager = applicationContext.getBean(CaffeineBasedLoadBalancerCacheManager.class);
            ConcurrentMap<String, Cache> cacheMap = (ConcurrentMap<String, Cache>) ReflectUtil.getFieldValue(balancerCacheManager, "cacheMap");
            for (Map.Entry<String, Cache> entry : cacheMap.entrySet()) {
                CaffeineCache cache = (CaffeineCache) entry.getValue();
                if (cache.getNativeCache().getIfPresent(e.getServiceName()) != null) {
                    cache.invalidate();
                }
            }
        }
    }
}
