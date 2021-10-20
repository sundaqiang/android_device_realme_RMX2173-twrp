#!/system/bin/sh
grep "ro.product.device=" /prop.default >/dev/null
if [ $? -eq 0 ]; then
  echo "change done"
else
  i=1
  while [ $i -le 10 ]; do
    if [ -f /cache/runtime.prop ]; then
      product=$(sed -n '/ro.build.product/ p' /cache/runtime.prop | cut -d'=' -f2)
      device=$(sed -n '/ro.commonsoft.ota/ p' /cache/runtime.prop | cut -d'=' -f2)
      soft=$(sed -n '/ro.separate.soft/ p' /cache/runtime.prop | cut -d'=' -f2)
      name=$(sed -n '/ro.oppo.market.name/ p' /cache/runtime.prop | cut -d'=' -f2 | sed 's/realme //')
      
      echo "product is ${product}"
      echo "device is ${device}"
      echo "soft is ${soft}"
      echo "name is ${name}"
      
      if [ "$device" ]; then
        echo "change device"
        sed -i "s/=RMX2173/=${device}/" /prop.default
        sed -i "s/=RMX2173/=${device}/" /default.prop
        sed -i "$ a ro.product.device=${device}" /prop.default
      else
        echo "pass change device"
        sed -i "s/=RMX2173/=RMX2175CN/" /prop.default
        sed -i "s/=RMX2173/=RMX2175CN/" /default.prop
        sed -i "$ a ro.product.device=RMX2175CN" /prop.default
      fi
      
      if [ "$product" ]; then
        echo "change product"
        sed -i "s/RMX2173/${product}/" /prop.default
        sed -i "s/RMX2173/${product}/" /default.prop
        sed -i "$ a ro.product.name=omni_${product}" /prop.default
      else
        echo "pass change product"
        sed -i "$ a ro.product.name=omni_RMX2173" /prop.default
      fi
      
      if [ "$soft" ]; then
        echo "change soft"
        sed -i "$ a ro.separate.soft=${soft}" /prop.default
      else
        echo "pass change soft"
        sed -i "$ a ro.separate.soft=20633" /prop.default
      fi
      
      if [ "$name" ]; then
        echo "change name"
        sed -i "s/Q2 Pro 5G/${name}/" /prop.default
        sed -i "s/Q2 Pro 5G/${name}/" /default.prop
        sed -i "$ a ro.product.model=${name}" /prop.default
      else
        echo "pass change name"
        sed -i "$ a ro.product.model=Q2 Pro 5G" /prop.default
      fi
      
      resetprop --file /prop.default
      resetprop --file /default.prop
      break
    else
      sleep 1
      let i++
    fi
  done
fi
stop modelchange
