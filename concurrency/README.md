# Reserved concurrency - Lambda throttling

Trong bài này chúng ta sẽ thực hành và quan sát xem điều gì sẽ xảy ra khi có quá nhiều invocation đồng thời đến lambda function.

## Tóm tắt các bước

1. Tạo và config lambda function
2. Cài đặt Apache Benmarking
3. Benmark lambda function
4. Quan sát và nhận xét kết quả

## 1. Tạo và config lambda function:

1. Tạo 1 lambda function với các config như sau:

- Function name: ConcurrencyTest
- Runtime: Node.js 16.x
- Advanced settings
  - Enable function URL
    - Auth type: NONE

**Lưu ý:** sử dụng Enable function URL - Auth type: NONE chỉ với mục đích testing, không khuyến khích sử dụng trên production vì function sẽ bị public và ai cũng có thể invoke function này.

2. Code:

```js
const doWork = (ms) => new Promise(resolve => setTimeout(resolve, ms))

exports.handler = async (event) => {
    await doWork(5000)
    return "OK"
}
```

3. Đi tới `Configuration` -> `Concurrency` -> `Edit` -> sửa `Reserved concurrency = 5`

4. Đi tới `Configuration` -> `Function URL` -> Copy function url và lưu lại

## 2. Cài đặt Apache Benmarking

#### Windows

Tải `Apache lounge`, giải nén và sử dụng tool `abs` trong thư mục `bin/`

#### Ubuntu

```
sudo apt update -y
sudo apt install -y apache2-utils
```

## 3. Benmark lambda function

```shell
ab -n 100 -c 50 https://<function-id>.lambda-url.<region>.on.aws/
```

Lệnh này sẽ gửi 100 request, trong đó 50 request đồng thời tới lambda function chúng ta vừa tạo

## 4. Quan sát và nhận xét kết quả

Quan sát số lượng request đã thực hiện, số request thành công / thất bại. Giải thích lý do?

Trong Console lambda, chuyển sang tab monitoring và quan sát các metrics của function
