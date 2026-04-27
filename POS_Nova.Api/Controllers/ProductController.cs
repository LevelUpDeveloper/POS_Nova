using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using POS_Nova.Application.Contracts;
using POS_Nova.Application.Features.Products.DTOs;
using POS_Nova.Domain.Entities;

namespace POS_Nova.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly IProductRepository _productRepository;

        public ProductController(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }


        [HttpPost]
        public async Task<IActionResult> Create(CreateProductDto dto)
        {
            var product = new Product
            {
                Name = dto.Name,
                Description = dto.Description,
                CategoryId = dto.CategoryId,
                ProviderId = dto.ProviderId,
                Stock = dto.Stock,
                SellPrice = dto.SellPrice,
                ImageUrl = dto.ImageUrl
            };
            await _productRepository.AddAsync(product);

            return Ok(product);
        }
    }
}
