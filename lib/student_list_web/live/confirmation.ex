defmodule StudentListWeb.Live.Confirmation do
  use Surface.Component

  prop support_email, :string, default: nil

  def render(assigns) do
    ~F"""
    <h1>Thanks for submitting your info!!!</h1>
    <p :if={@support_email}>
      Questions or comments? Email <a href={"mailto:#{@support_email}?Subject=Support"}>{@support_email}</a>
    </p>
    """
  end
# 
#   <div class="container">
#   <div class="alert alert-success">
#     <h3>Thanks</h3>
#     The information below has been submitted for the school directory.
#     <%= if @support_email do %>
#       <br>Questions or comments? Email <a href='mailto:<%= @support_email %>?Subject=Support'>
#         <%= @support_email %></a>
#     <% end %>
#     <br><a class="alert-link" href='/'>Add another student</a>
#   </div>
#   <div class="students">
#     <%= for student <- @students do %>
#       <div class="class_name">
#         <h2><%= student.class.name %></h2>
#         <h3 class="teacher_name"><%= student.class.teacher %></h3>
#       </div>
#       <div class="student_name_bus">
#         <h4 class="student_name"><%= student.last_name %>, <%= student.first_name %></h4>
#         <%= if student.bus.should_display do %>
#           <span class="bus"><%= student.bus.name %></span><br>
#         <% end %>
#         <br>
#       </div>
#       <%= for {parent_list, address} <- ClassList.DirectoryView.group_parents(student) do %>
#         <%= for parent <- parent_list do %>
#           <div class="parent_name">
#             <span><b><%= parent.first_name %> <%= parent.last_name %></b></span><br>
#             <div class="parent_contact">
#               <%= if ClassList.DirectoryView.not_empty(parent.email) do %>
#                 <span class="email"><%= parent.email %></span><br>
#               <% end %>
#               <%= if ClassList.DirectoryView.not_empty(parent.mobile_phone) do %>
#                 <span class="phone"><%= parent.mobile_phone %></span><br>
#               <% end %>
#               <br>
#             </div>
#           </div>
#         <% end %>
#         <div class="parent_address">
#           <%= if ClassList.DirectoryView.not_empty(address.address1) do %>
#             <span class="address_street"><%= address.address1 %></span><br>
#           <% end %>
#           <%= if ClassList.DirectoryView.not_empty(address.address2) do %>
#             <span class="address_street2"><%= address.address2 %></span><br>
#           <% end %>
#           <%= if ClassList.DirectoryView.not_empty(address.city) do %>
#             <span class="address_city"><%= address.city %>,</span>
#           <% end %>
#           <%= if ClassList.DirectoryView.not_empty(address.state) do %>
#             <span class="address_state"><%= address.state %>  </span>
#           <% end %>
#           <%= if ClassList.DirectoryView.not_empty(address.zip) do %>
#             <span class="address_zip"><%= address.zip %></span><br>
#           <% end %>
#           <%= if ClassList.DirectoryView.not_empty(address.phone) do %>
#             <span class="phone"><%= address.phone %></span><br>
#           <% end %>
#         </div>
#         <br>
#       <% end %>
#       <p class="notes"><%= student.notes %></p>
#     <% end %>
#   </div>
# </div>
end
